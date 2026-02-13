# Firebase DataConnect

GraphQL API for the Unity Aid application powered by Firebase DataConnect.

## Quick Links

- **Configuration**: `../../dataconnect/`
- **Schema**: `../../dataconnect/schema/schema.gql`
- **Connectors**: `../../dataconnect/example/`
- **Rules**: `../../dataconnect/dataconnect.yaml`

## What is DataConnect?

Firebase DataConnect provides a managed GraphQL API that:
- Connects to Firestore database
- Provides type-safe queries & mutations
- Handles authentication & authorization
- Auto-scales with your application
- Reduces backend complexity (no custom resolvers needed for simple operations)

## Setup & Deployment

```bash
# From project root
firebase deploy --only dataconnect
```

## Schema

Define your data model in `../../dataconnect/schema/schema.gql`:

```graphql
type Movie {
  id: UUIDv4!
  title: String!
  description: String
  releaseYear: Int
  createdAt: DateTime!
  createdBy: Ref<User>!
}

type User {
  id: UUIDv4!
  username: String!
  email: String!
  createdAt: DateTime!
  movies: [Ref<Movie>!]
}
```

## Connectors (Queries & Mutations)

### Queries
Define read operations in `../../dataconnect/example/queries.gql`:

```graphql
query GetMovieById($id: UUIDv4!) {
  movie(id: $id) {
    id
    title
    description
    releaseYear
  }
}

query ListMovies {
  movies {
    id
    title
    releaseYear
  }
}
```

### Mutations
Define write operations in `../../dataconnect/example/mutations.gql`:

```graphql
mutation CreateMovie($title: String!, $releaseYear: Int!) {
  movie_insert(data: {title: $title, releaseYear: $releaseYear}) {
    id
    title
  }
}
```

## Client Integration

### In Flutter Frontend
```dart
// Usage example (auto-generated from schema)
final movie = await GetMovieById({'id': movieId}).execute();
```

### In Cloud Functions
```typescript
// Usage example
const response = await dataconnectInstance
  .executeQuery({
    query: GetMovieById,
    variables: { id: movieId }
  });
```

## Firestore Connector

Automatically connects to your Firestore database via `dataconnect.yaml`:

```yaml
apiVersion: dataconnect.googleapis.com/v1alpha1
kind: FirestoreConnector
metadata:
  name: default
spec:
  database: firestore-default
```

## Authorization

Control access via DataConnect permissions in `dataconnect.yaml`:

```yaml
rules:
  - selector: "Movie.*"
    allow: "auth.uid != null"
  - selector: "User.email"
    allow: "resource.uid == auth.uid"
```

## Generated Code

After deploying DataConnect, auto-generated code is available in:
- **Flutter**: `frontend/lib/dataconnect_generated/`
- **Web/Other**: JavaScript SDK (can be generated)

## Useful Commands

```bash
# Deploy DataConnect
firebase deploy --only dataconnect

# View DataConnect status & info
firebase dataconnect:info

# Generate client code
firebase dataconnect:codegen

# Test locally (watch mode)
firebase emulators:start --only dataconnect
```

## References

- [Firebase DataConnect Docs](https://firebase.google.com/docs/dataconnect)
- [GraphQL Best Practices](https://graphql.org/learn/)
- [Firestore Data Modeling](https://firebase.google.com/docs/firestore/manage-data/structure-data)

## Integration with Cloud Functions

DataConnect complements Cloud Functions:
- **Cloud Functions**: Custom business logic, external APIs, AI operations
- **DataConnect**: CRUD operations, structured data access

Example workflow:
1. Client calls DataConnect query to fetch data
2. Cloud Function processes business logic
3. Cloud Function mutates data via DataConnect or Firestore Admin SDK
