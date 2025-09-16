<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Note;
use Illuminate\Support\Facades\Cache;

class HomeController extends Controller
{
    public function index()
    {
        // Database and Redis test
        $dbStatus = 'Database Connected ✅';
        $redisStatus = 'Hello from Redis!';

        // Fetch cached notes
        $notes = Cache::remember('notes', 60, function () {
            return Note::all();
        });

        return view('welcome', compact('dbStatus', 'redisStatus', 'notes'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required',
            'content' => 'required',
        ]);

        $note = Note::create($request->only('title', 'content'));

        // Update cache
        Cache::put('notes', Note::all(), 60);

        return redirect('/');
    }
}

