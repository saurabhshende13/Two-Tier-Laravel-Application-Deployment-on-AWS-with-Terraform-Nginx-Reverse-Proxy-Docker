<!DOCTYPE html>
<html>
<head>
    <title>Laravel Notes App</title>
</head>
<body>
    <h1>Welcome to Laravel PHP 8.2 App</h1>
    <p>{{ $dbStatus }}</p>
    <p>{{ $redisStatus }}</p>

    <h2>Add a Note</h2>
    <form method="POST" action="/notes">
        @csrf
        <input type="text" name="title" placeholder="Title" required>
        <br>
        <textarea name="content" placeholder="Content" required></textarea>
        <br>
        <button type="submit">Add Note</button>
    </form>

    <h2>All Notes</h2>
    <ul>
        @foreach ($notes as $note)
            <li><strong>{{ $note->title }}:</strong> {{ $note->content }}</li>
        @endforeach
    </ul>
</body>
</html>

