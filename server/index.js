const express = require("express");
var http = require('http');
const app = express();
const mongoose = require("mongoose");
const port = process.env.PORT || 3000;
const server = http.createServer(app);
const Room = require('./model/room');
const io = require('socket.io')(server);
const getWord = require('./api/getWord') ; 
const cors = require('cors');
app.use(cors());
//middleware 
app.use(express.json());

// connection to db 
const db = "mongodb+srv://deepprabh832:helloworld@cluster0.suuht63.mongodb.net/?retryWrites=true&w=majority"

mongoose.connect(db).then(() => {
    console.log("Database Connection successful");
}).catch((e) => {
    console.log(e) ; 
})

// it gets activated when connection gets established 
io.on('connection' , (socket) =>  {

    console.log('socket connected'); 
    socket.emit('connected' , 'connected to server');
    // this socket now hears the events . it hears the create-game which we emitted in the paint screen. and it gets data with itself . 
    socket.on('create-game' , async ({nickname , name  , occupancy , maxRounds }) => {
        console.log("create game socket reached")
        try{

            const existingRoom = await Room.findOne({name}) ; 
            if(existingRoom){
                socket.emit('notCorrectGame', 'Room with that name already exists !!'); 
                return ; 
            }

            // creating room with its data 
            let room  = new Room() ; 
            const word = getWord() ; 
            room.word = word ; 
            room.name= name; 
            room.occupancy = occupancy ; 
            room.maxRounds = maxRounds ; 

            let player = {
                socketId:socket.id , 
                nickname, 
                isPartyLeader : true , 
            }

            room.players.push(player); 
            room = await room.save();  // saving room
            socket.join(name) ; 

            // it again emits the signal updateRoom and then sends room as the data with itself 
            io.to(name).emit('updateRoom' , room);
            console.log("updata room socket emitted")

        }catch(err){
            console.log(err); 
        }
    })



    socket.on('join-game' ,async ({nickname , name }) => {
        console.log("join game socket reached")
        try{
            let room = await Room.findOne({name}) ; 

            if(!room){
                console.log("not correct game socket emitted") 
                socket.emit('notCorrectGame' , 'Please enter a correct room name') ; 
                return ;
            }
   // isJoin means that if the room is available to join for players( ie if the room capacity has not yet been reached)
            if(room.isJoin){
                let player = {
                    socketId : socket.id , 
                    nickname , 
                }

                room.players.push(player) ; 
                socket.join(name) ; 
            

            if(room.players.length === room.occupancy){
                room.isJoin = false ; 
            }

            room.turn = room.players[room.turnIndex] ; 
            room = await room.save() ; 
            console.log("update room socket emitted by join event")
            io.to(name).emit('updateRoom' , room); 
        }

        else{
            socket.emit('notCorrectGame' , 'The game is in progress , try again later !'); 
        }

        }catch(err){
                console.log(err) ;
        }
    });


    // white board 
    socket.on('paint', ({details , roomName}) =>{
        io.to(roomName).emit('points' , {details:details});
    })

    //color change
    socket.on('color-change' , ({color , roomName}) => {
        io.to(roomName).emit('color-change' , color);
    })

    //stroke width
    socket.on('stroke-width' , ({value , roomName}) => {
        io.to(roomName).emit('stroke-width' , value); 
    })

    socket.on('clean-screen', (roomName) => {
        io.to(roomName).emit('clear-screen', '');
    })

    socket.on('msg' , async (data) => {
        try{
            if(data.msg === data.word){
                let room = await Room.findOne({name: data.roomName});
                let userPlayer = room.players.find(player => player.nickname === data.username);
                if(userPlayer && data.timeTaken !== 0){
                    userPlayer.points += Math.round((200/data.timeTaken) * 10);
                }
                
                // Change turn logic
                let index = room.turnIndex;
                if(index + 1 === room.players.length){
                    room.currentRound += 1;
                }
                if(room.currentRound <= room.maxRounds){
                    const word = getWord();
                    room.word = word;
                    room.turnIndex = (index + 1) % room.players.length;
                    room.turn = room.players[room.turnIndex];
                    room = await room.save();
                    io.to(data.roomName).emit('change-turn', room);
                } else {
                    // Save final points before showing leaderboard
                    await room.save();
                    io.to(data.roomName).emit('show-leaderboard', room.players);
                }
            } else {
                io.to(data.roomName).emit('msg', {
                    username: data.username,
                    msg: data.msg,
                    guessedUserCtr: data.guessedUserCtr
                });
            }
        } catch(error){
            console.log(error.toString());
        }
    })

    socket.on('change-turn' , async(name)=>{
        try{
            let room = await Room.findOne({name});
            let index = room.turnIndex ; 
            if(index+1 === room.players.length){
                room.currentRound += 1 ; 
            }  
            if(room.currentRound <= room.maxRounds){
                const word = getWord() ; 
                room.word = word;
                room.turnIndex = (index + 1) % room.players.length ; 
                room.turn = room.players[room.turnIndex] ; 
                room = await room.save() ; 
                io.to(name).emit('change-turn' , { 'room': room }); 
            }else{
                //show leaderboard
                io.to(name).emit('show-leaderboard' , room.players);
            }

        }
        catch(err){
            console.log(err) ; 
        }
    })


    socket.on('updateScore' , async (name)=>{
        try{
            const room = await Room.findOne({name}); 
            io.to(name).emit('updateScore' , room);
        }
        catch(error){
            console.log(error);
        }
    })

    socket.on('disconnect' , async () => {
        try{
            let room = await Room.findOne({"players.socketId" : socket.id});
            for(let i = 0 ; i < room.players.length;i++){

                if(room.players[i].socketId === socket.id){
                    room.players.slice(i , 1);
                    break ; 
                }
            }
            room = await room.save() ; 

            if(room.players.length === 1){
                socket.broadcast.to(room.name).emit('show-leaderboard', room.players);
            }
            else{
                socket.broadcast.to(room.name).emit('user-disconnected', room);
            }
        }catch(err){

        }
    })
})


server.listen(port,"0.0.0.0",  () => {
    console.log("Server is running at port "+ port) ; 
})