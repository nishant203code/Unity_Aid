# Backend Setup Guide

This guide helps you set up and understand the backend architecture for Unity Aid.

## Folder Structure

```
Unity_Aid/
├── backend/                    # Backend documentation & organization (NEW)
│   ├── README.md              # Main backend guide
│   ├── cloud-functions/       # Cloud Functions documentation
│   │   └── README.md
│   └── dataconnect/           # DataConnect documentation
│       └── README.md
├── functions/                 # Firebase Cloud Functions (TypeScript)
│   ├── src/
│   ├── lib/                   # Compiled JavaScript output
│   ├── package.json
│   └── tsconfig.json
├── dataconnect/               # Firebase DataConnect GraphQL API
│   ├── schema/
│   ├── example/
│   └── dataconnect.yaml
├── firestore.rules            # Firestore security rules
├── firestore.indexes.json     # Firestore index configurations
├── frontend/                  # Flutter mobile app
├── unityaid/                  # Node.js utilities module
└── README.md
```

## Key Files

| Location | Purpose |
|----------|---------|
| `/functions/` | ServerlessTypeScript backend functions |
| `/dataconnect/` | Managed GraphQL API for Firestore |
| `/firestore.rules` | Database security rules |
| `/firestore.indexes.json` | Firestore query optimization |
| `/backend/` | Backend documentation & guides |

## Getting Started

### 1. Install Firebase CLI
```bash
npm install -g firebase-tools
firebase login
firebase use unity-aid-e8db3
```

### 2. Install Cloud Functions Dependencies
```bash
cd functions
npm install
```

### 3. Local Development
```bash
# Build TypeScript
cd functions
npm run build:watch

# Start Firebase Emulator (in another terminal)
firebase emulators:start
```

### 4. Deploy to Firebase
```bash
# Deploy cloud functions
firebase deploy --only functions

# Deploy dataconnect
firebase deploy --only dataconnect

# Deploy security rules
firebase deploy --only firestore:rules

# Deploy everything
firebase deploy
```

## Development Workflow

### For Backend (Cloud Functions + DataConnect)

1. **Make changes** in `functions/src/` or `dataconnect/`
2. **Build & Test locally**:
   ```bash
   cd functions
   npm run build
   firebase emulators:start
   ```
3. **Verify in Emulator UI** at `http://localhost:4000`
4. **Commit & Push**:
   ```bash
   git add .
   git commit -m "Backend: [description]"
   git push
   ```
5. **Deploy when ready**:
   ```bash
   firebase deploy
   ```

### For DataConnect Schema Changes

1. Edit `dataconnect/schema/schema.gql`
2. Add queries/mutations in `dataconnect/example/`
3. Deploy:
   ```bash
   firebase deploy --only dataconnect
   ```
4. Auto-generated code updates in `frontend/lib/dataconnect_generated/`

## Firestore Structure

### Collections (based on DataConnect schema)

```
firestore/
├── movies/          (Movie collection)
│   └── {movieId}
│       ├── title: string
│       ├── releaseYear: number
│       └── createdBy: reference (users)
├── users/           (User collection)
│   └── {userId}
│       ├── username: string
│       ├── email: string
│       └── movies: array of references
└── reviews/         (Review collection)
    └── {reviewId}
        ├── content: string
        ├── rating: number
        └── author: reference (users)
```

## Security Rules

Edit `firestore.rules` to control access:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Anyone can read movies, only authenticated users can create
    match /movies/{movieId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.createdBy;
    }
  }
}
```

Deploy rules:
```bash
firebase deploy --only firestore:rules
```

## Cloud Functions Architecture

### Genkit Integration

Your project includes Google Genkit for AI operations:

```typescript
import { defineFlow } from "@genkit-ai/flow";

export const aiFunction = defineFlow(
  { inputSchema: InputType, outputSchema: OutputType },
  async (input) => {
    // AI logic
  }
);
```

### Express Server Example

```typescript
import * as express from "express";
import { onRequest } from "firebase-functions/https";

const app = express();

app.get("/api/data", (req, res) => {
  res.json({ message: "Hello!" });
});

export const api = onRequest(app);
```

## Environment Variables

Set in Firebase Console → Project Settings → Runtime environment variables:

```env
OPENAI_API_KEY=sk-...
API_KEY=your-api-key
DATABASE_URL=https://project.firebaseio.com
```

Access in functions:
```typescript
const openaiKey = process.env.OPENAI_API_KEY;
```

## Monitoring & Debugging

### View Function Logs
```bash
firebase functions:log
firebase functions:log --follow  # Real-time logs
```

### Firestore Metrics
Firebase Console → Firestore → Usage

### DataConnect Issues
Firebase Console → Data Connect → Logs

### Performance Tips
- Use indexes for frequently queried fields
- Paginate large result sets
- Cache at the client level when possible
- Batch write operations

## Troubleshooting

### Functions not deploying
```bash
firebase deploy --only functions --force
npm run lint --fix
npm run build
```

### Firestore rules errors
```bash
firebase emulators:start
# Test in emulator first before real deployment
```

### DataConnect schema issues
- Validate GraphQL syntax
- Check that types match Firestore collections
- Verify references point to existing types

## Next Steps

1. Read [`backend/README.md`](./README.md) for detailed backend guide
2. Review [`backend/cloud-functions/README.md`](./cloud-functions/README.md) for function development
3. Review [`backend/dataconnect/README.md`](./dataconnect/README.md) for GraphQL API setup
4. Explore Firebase Console for real-time monitoring
5. Set up CI/CD for automated deployments (GitHub Actions recommended)

## Useful Links

- [Firebase Console](https://console.firebase.google.com)
- [Firebase Cloud Functions Docs](https://firebase.google.com/docs/functions)
- [Firebase DataConnect Docs](https://firebase.google.com/docs/dataconnect)
- [Genkit Docs](https://ai.google.dev/gemini-api/docs/genkit)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
