# Scribble

Scribble is a real-time, multiplayer drawing and guessing game inspired by Pictionary. Players join rooms, take turns drawing a word, and others try to guess it within a time limit. The game is built with Flutter for the client and Node.js (Socket.IO) for the server, supporting web, Android, iOS, Windows, macOS, and Linux.

## Features

- 🎨 Real-time multiplayer drawing and guessing
- 🏠 Create or join private game rooms
- 🖌️ Smooth, responsive drawing canvas
- 💬 Live chat and guess system
- 🏆 Scoreboard and leaderboards
- ⏱️ Timed rounds and turn management
- 🔒 Secure room joining with unique codes
- 🌐 Cross-platform support (Web, Android, iOS, Desktop)
- 👤 Custom player names and avatars
- 📱 Responsive UI for all devices

## Tech Stack

### Frontend (Client)

- **Flutter**: Cross-platform UI toolkit
- **Dart**: Programming language for Flutter
- **Socket.IO Client**: Real-time communication

### Backend (Server)

- **Node.js**: JavaScript runtime
- **Express.js**: Web framework
- **Socket.IO**: Real-time, bidirectional communication

### Other

- **Platform Support**: Android, iOS, Web, Windows, macOS, Linux
- **State Management**: Flutter’s built-in state management
- **Custom Drawing Engine**: For smooth, real-time canvas updates

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Node.js](https://nodejs.org/)
- [npm](https://www.npmjs.com/)

### Setup

#### 1. Clone the repository

```sh
git clone https://github.com/your-username/scribble.git
cd scribble
```

#### 2. Install Flutter dependencies

```sh
flutter pub get
```

#### 3. Install server dependencies

```sh
cd server
npm install
```

#### 4. Start the server

```sh
node index.js
```

#### 5. Run the Flutter app

```sh
flutter run
```

## Folder Structure

- `lib/` - Flutter client code
- `server/` - Node.js backend
- `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/` - Platform-specific code

## Contributing

Contributions are welcome! Please open issues or submit pull requests.

## License

MIT License
