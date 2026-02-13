# Cloud Functions

Firebase Cloud Functions for the Unity Aid backend.

## Quick Links

- **Source Code**: `../../functions/src/`
- **Build Output**: `../../functions/lib/`
- **Config**: `../../functions/package.json`, `../../functions/tsconfig.json`
- **Eslint**: `../../functions/.eslintrc.js`

## Setup & Development

```bash
cd ../../functions

# Install dependencies
npm install

# Start development (watch + serve)
npm run build:watch
npm run serve

# Or in separate terminals:
npm run build:watch    # Terminal 1
npm run serve          # Terminal 2

# Deploy to Firebase
npm run deploy

# View logs
npm run logs
```

## Available Scripts

| Script | Purpose |
|--------|---------|
| `npm run lint` | Check TypeScript & JavaScript for linting errors |
| `npm run build` | Compile TypeScript to JavaScript |
| `npm run build:watch` | Watch for changes and recompile |
| `npm run serve` | Start Firebase Emulator Suite for local testing |
| `npm run shell` | Interactive shell for testing functions |
| `npm run deploy` | Deploy to Firebase |
| `npm run logs` | Stream function execution logs |

## Features

- **TypeScript Support**: Type-safe backend code
- **Express Integration**: Use Express routing in Cloud Functions
- **Genkit AI**: Built-in support for AI-powered functions
- **Firebase Admin SDK**: Direct Firestore, Authentication, Storage access
- **Local Emulation**: Test locally before deploying

## Function Types Supported

### HTTP Triggers
```typescript
import { onRequest } from "firebase-functions/https";

export const myFunction = onRequest((request, response) => {
  response.send("Hello!");
});
```

### Firestore Triggers
```typescript
import { onDocumentWritten } from "firebase-functions/v2/firestore";

export const onDataChange = onDocumentWritten("path/{docId}", async (event) => {
  // Handle document changes
});
```

### Scheduled Functions
```typescript
import { onSchedule } from "firebase-functions/v2/scheduler";

export const scheduledTask = onSchedule("every day 10:00", async (context) => {
  // Run daily
});
```

## AI Features (Genkit)

This project includes Google Genkit for AI operations:

```typescript
import { defineFlow, startFlow } from "@genkit-ai/flow";

export const aiFunction = defineFlow(
  { inputSchema: InputType, outputSchema: OutputType },
  async (input) => {
    // AI logic here
  }
);
```

See `../../functions/src/index.ts` for examples and [Genkit Docs](https://ai.google.dev/gemini-api/docs/genkit).

## Environment Setup

Set environment variables in Firebase Console → Project Settings → Environment Variables:

```env
OPENAI_API_KEY=your_key
API_KEY=your_key
```

Access in functions:
```typescript
import { defineSecret } from "firebase-functions/params";

const openaiKey = defineSecret("OPENAI_API_KEY");

export const myAiFunction = onRequest({ secrets: [openaiKey] }, (request, response) => {
  const key = openaiKey.value(); // Access secret
});
```

## Deployment Checklist

- [ ] Run `npm run lint` - no errors
- [ ] Run `npm run build` - successful compile
- [ ] Test locally: `npm run serve`
- [ ] Update `firestore.rules` if needed
- [ ] Deploy: `npm run deploy`
- [ ] Check logs: `npm run logs`

## Troubleshooting

### "Cannot find module" error
```bash
npm install
npm run build
```

### Functions not found after deploy
```bash
firebase deploy --only functions --force
```

### Local emulator won't start
- Ensure port 5001 (functions) & 4000 (UI) are free
- Kill any existing emulator: `lsof -ti:5001 | xargs kill`

### TypeScript errors
```bash
npm run lint --fix   # Auto-fix linting issues
```

## Next Steps

1. Define your API endpoints in `src/index.ts`
2. Add database operations via Firestore Admin SDK
3. Implement authentication checks in middleware
4. Add unit tests in `src/__tests__/`
5. Deploy and monitor via Firebase Console
