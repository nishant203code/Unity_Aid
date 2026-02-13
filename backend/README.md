# Backend - Unity Aid

This folder contains all backend services for the Unity Aid application.

## Structure

```
backend/
├── cloud-functions/      # Firebase Cloud Functions (TypeScript/Node.js)
├── dataconnect/          # Firebase DataConnect (GraphQL API)
└── README.md             # This file
```

## Services Overview

### Cloud Functions
Firebase Cloud Functions provide serverless backend logic:
- **Location**: `../functions/` (symlinked to `cloud-functions/`)
- **Runtime**: Node.js 24
- **Framework**: Express + Firebase Functions v2
- **AI Integration**: Google Genkit for AI-powered operations
- **Documentation**: See [Cloud Functions Setup](#cloud-functions-setup)

### DataConnect
Firebase DataConnect provides a managed GraphQL API:
- **Location**: `../dataconnect/`
- **Type**: GraphQL Schema + Connectors
- **Database**: Firestore
- **Documentation**: See [DataConnect Setup](#dataconnect-setup)

## Quick Start

### Prerequisites
- Node.js 24+ installed
- Firebase Auth (logged in via `firebase login`)
- Firebase project (from Firebase Console)

### 1. Cloud Functions Setup

Navigate to the functions folder and install dependencies:

```bash
cd ../functions
npm install
```

Build the TypeScript code:

```bash
npm run build
```

Start local emulator:

```bash
npm run serve
```

Deploy to Firebase:

```bash
npm run deploy
```

For development with hot reload:

```bash
npm run build:watch
```

### 2. DataConnect Setup

DataConnect is managed from the Firebase Console:
1. Go to **Firebase Console** → Your Project → **Data Connect**
2. Define your schema in `../dataconnect/schema/schema.gql`
3. Create connectors (queries/mutations) in `../dataconnect/example/`
4. Deploy via `firebase deploy --only dataconnect`

## Environment Variables

Set up in Firebase console (`Project Settings` → `Environment Variables`):
- `API_KEY` - Your API key
- `OPENAI_API_KEY` - For AI features (if using Genkit)
- Other service credentials as needed

## Firebase Emulator Suite

To test locally before deployment:

```bash
# Start all emulators
firebase emulators:start

# Or just functions emulator
npm run serve
```

Access emulator UI at `http://localhost:4000`

## Deployment

### Deploy only functions:
```bash
firebase deploy --only functions
```

### Deploy only DataConnect:
```bash
firebase deploy --only dataconnect
```

### Deploy everything:
```bash
firebase deploy
```

## Useful Firebase Commands

```bash
# View function logs
firebase functions:log

# Open functions shell for testing
firebase functions:shell

# List deployed functions
firebase functions:list

# View DataConnect status
firebase dataconnect:info
```

## Firestore & Security Rules

- **Firestore rules**: `../firestore.rules`
- **Indexes**: `../firestore.indexes.json`

Deploy security rules:

```bash
firebase deploy --only firestore:rules
```

## Architecture

```
Frontend (Flutter App)
    ↓ HTTP/WebSocket
Cloud Functions (Node.js + Express)
    ↓ Admin SDK
Firestore Database
    ↓
DataConnect (GraphQL API)
```

## Debugging

### Check function logs:
```bash
firebase functions:log --follow
```

### Local testing in functions shell:
```bash
npm run shell
```

### Check function errors in Firebase Console
Console → Functions → Logs

## Performance & Scaling

- Maximum 10 function instances (configurable in `index.ts`)
- Firestore: Auto-scales, cold start ~100-200ms
- DataConnect: Managed by Google, optimized for mobile clients

## References

- [Firebase Functions Docs](https://firebase.google.com/docs/functions)
- [DataConnect Docs](https://firebase.google.com/docs/dataconnect)
- [Genkit Docs](https://ai.google.dev/gemini-api/docs/genkit)
- [Firestore Rules](https://firebase.google.com/docs/firestore/security)
