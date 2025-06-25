import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Quiz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      home: const CategorySelectionPage(),
    );
  }
}

class Category {
  final String name;
  final IconData icon;
  final Color color;

  const Category(this.name, this.icon, this.color);
}

class CategorySelectionPage extends StatelessWidget {
  const CategorySelectionPage({super.key});

  final List<Category> categories = const [
    Category('General Knowledge', Icons.public, Colors.blue),
    Category('Science', Icons.science, Colors.green),
    Category('History', Icons.history, Colors.orange),
    Category('Movies', Icons.movie, Colors.purple),
    Category('Geography', Icons.map, Colors.red),
    Category('Sports', Icons.sports_soccer, Colors.teal),
    Category('Technology', Icons.computer, Colors.cyan),
    Category('Music', Icons.music_note, Colors.pink),
    Category('Art', Icons.palette, Colors.deepOrange),
    Category('Literature', Icons.menu_book, Colors.brown),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Quiz Category'),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: categories.map((category) {
          return Card(
            color: category.color.withOpacity(0.2),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizHomePage(category: category.name),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(category.icon, size: 50, color: category.color),
                  const SizedBox(height: 10),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: category.color,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class QuizHomePage extends StatefulWidget {
  final String category;
  const QuizHomePage({super.key, required this.category});

  @override
  _QuizHomePageState createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  late int _timeLeft;
  late Timer _timer;
  late List<Map<String, dynamic>> _currentQuestions;
  final Random _random = Random();

  final Map<String, List<Map<String, dynamic>>> _questionBank = {
    'General Knowledge': [
      {
        'question': 'What is the capital of France?',
        'answers': ['London', 'Paris', 'Berlin', 'Madrid'],
        'correctAnswer': 1,
        'image': 'https://cdn.pixabay.com/photo/2014/11/22/00/56/eiffel-tower-540835_1280.jpg',
        'timeLimit': 15,
      },
      {
        'question': 'Which planet is known as the Red Planet?',
        'answers': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
        'correctAnswer': 1,
        'image': 'https://cdn.pixabay.com/photo/2011/12/13/14/39/mars-11012_1280.jpg',
        'timeLimit': 20,
      },
      {
        'question': 'What is the largest ocean on Earth?',
        'answers': ['Atlantic', 'Indian', 'Pacific', 'Arctic'],
        'correctAnswer': 2,
        'image': 'https://cdn.pixabay.com/photo/2013/07/18/10/56/earth-163709_1280.jpg',
        'timeLimit': 15,
      },
    ],
    'Science': [
      {
        'question': 'What is the largest mammal?',
        'answers': ['Elephant', 'Blue Whale', 'Giraffe', 'Hippopotamus'],
        'correctAnswer': 1,
        'image': 'https://cdn.pixabay.com/photo/2016/11/14/04/45/elephant-1822636_1280.jpg',
        'timeLimit': 25,
      },
      {
        'question': 'What is H2O?',
        'answers': ['Hydrogen', 'Helium', 'Water', 'Carbon Dioxide'],
        'correctAnswer': 2,
        'image': 'https://cdn.pixabay.com/photo/2017/10/04/09/56/laboratory-2815641_1280.jpg',
        'timeLimit': 15,
      },
      {
        'question': 'What is the chemical symbol for gold?',
        'answers': ['Go', 'Gd', 'Au', 'Ag'],
        'correctAnswer': 2,
        'image': 'https://cdn.pixabay.com/photo/2013/07/13/11/34/gold-157821_1280.png',
        'timeLimit': 15,
      },
    ],
    'History': [
      {
        'question': 'In which year did World War II end?',
        'answers': ['1943', '1945', '1947', '1950'],
        'correctAnswer': 1,
        'image': 'https://cdn.pixabay.com/photo/2019/11/07/22/44/war-4609870_1280.jpg',
        'timeLimit': 20,
      },
      {
        'question': 'Who was the first president of the United States?',
        'answers': ['Thomas Jefferson', 'John Adams', 'George Washington', 'Abraham Lincoln'],
        'correctAnswer': 2,
        'image': 'https://cdn.pixabay.com/photo/2017/07/04/10/07/george-washington-2470891_1280.jpg',
        'timeLimit': 20,
      },
    ],
    'Movies': [
      {
        'question': 'Who directed the movie "Inception"?',
        'answers': ['Steven Spielberg', 'Christopher Nolan', 'James Cameron', 'Martin Scorsese'],
        'correctAnswer': 1,
        'image': 'https://cdn.pixabay.com/photo/2016/11/29/08/42/cinema-1869389_1280.jpg',
        'timeLimit': 15,
      },
      {
        'question': 'Which actor played Jack in Titanic?',
        'answers': ['Brad Pitt', 'Leonardo DiCaprio', 'Tom Cruise', 'Johnny Depp'],
        'correctAnswer': 1,
        'image': 'https://cdn.pixabay.com/photo/2013/07/12/18/39/titanic-153547_1280.png',
        'timeLimit': 15,
      },
    ],
    'Geography': [
      {
        'question': 'Which is the longest river in the world?',
        'answers': ['Amazon', 'Nile', 'Yangtze', 'Mississippi'],
        'correctAnswer': 1,
        'image': 'https://cdn.pixabay.com/photo/2017/01/19/23/46/panorama-1993645_1280.jpg',
        'timeLimit': 20,
      },
      {
        'question': 'Which country has the most time zones?',
        'answers': ['USA', 'Russia', 'China', 'France'],
        'correctAnswer': 3,
        'image': 'https://cdn.pixabay.com/photo/2013/07/13/11/44/world-157739_1280.png',
        'timeLimit': 20,
      },
    ],
    'Sports': [
      {
        'question': 'Which country won the 2018 FIFA World Cup?',
        'answers': ['Germany', 'Brazil', 'France', 'Argentina'],
        'correctAnswer': 2,
        'image': 'https://cdn.pixabay.com/photo/2016/06/02/02/33/triump-1430665_1280.jpg',
        'timeLimit': 15,
      },
      {
        'question': 'How many players are on a baseball team?',
        'answers': ['7', '9', '11', '13'],
        'correctAnswer': 1,
        'image': 'https://cdn.pixabay.com/photo/2013/07/12/18/20/baseball-153546_1280.png',
        'timeLimit': 15,
      },
    ],
    'Technology': [
      {
        'question': 'Which company developed the Android OS?',
        'answers': ['Apple', 'Microsoft', 'Google', 'Samsung'],
        'correctAnswer': 2,
        'image': 'https://cdn.pixabay.com/photo/2015/12/04/14/05/code-1076536_1280.jpg',
        'timeLimit': 15,
      },
      {
        'question': 'What does "HTTP" stand for?',
        'answers': ['HyperText Transfer Protocol', 'High-Tech Text Process', 'Hyper Transfer Text Protocol', 'High Transfer Text Process'],
        'correctAnswer': 0,
        'image': 'https://cdn.pixabay.com/photo/2016/11/19/14/00/code-1839406_1280.jpg',
        'timeLimit': 20,
      },
    ],
    'Music': [
      {
        'question': 'Who is known as the "King of Pop"?',
        'answers': ['Elvis Presley', 'Michael Jackson', 'Prince', 'Justin Bieber'],
        'correctAnswer': 1,
        'image': 'https://cdn.pixabay.com/photo/2016/11/22/19/49/michael-jackson-1850081_1280.jpg',
        'timeLimit': 15,
      },
      {
        'question': 'Which instrument has 88 keys?',
        'answers': ['Guitar', 'Violin', 'Piano', 'Harp'],
        'correctAnswer': 2,
        'image': 'https://cdn.pixabay.com/photo/2015/05/15/14/50/piano-768771_1280.jpg',
        'timeLimit': 15,
      },
    ],
    'Art': [
      {
        'question': 'Who painted the Mona Lisa?',
        'answers': ['Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Michelangelo'],
        'correctAnswer': 2,
        'image': 'https://cdn.pixabay.com/photo/2017/08/30/12/45/mona-lisa-2696949_1280.jpg',
        'timeLimit': 15,
      },
      {
        'question': 'Which art movement is Salvador Dalí associated with?',
        'answers': ['Impressionism', 'Surrealism', 'Cubism', 'Expressionism'],
        'correctAnswer': 1,
        'image': 'https://cdn.pixabay.com/photo/2012/11/28/10/55/dali-67693_1280.jpg',
        'timeLimit': 20,
      },
    ],
    'Literature': [
      {
        'question': 'Who wrote "Romeo and Juliet"?',
        'answers': ['Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain'],
        'correctAnswer': 1,
        'image': 'https://cdn.pixabay.com/photo/2015/11/19/21/14/book-1052014_1280.jpg',
        'timeLimit': 15,
      },
      {
        'question': 'What is the first book in the Harry Potter series?',
        'answers': ['The Chamber of Secrets', 'The Goblet of Fire', "The Philosopher's Stone", 'The Prisoner of Azkaban'],
        'correctAnswer': 2,
        'image': 'https://cdn.pixabay.com/photo/2016/09/10/17/18/book-1659717_1280.jpg',
        'timeLimit': 15,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _generateNewQuestionSet();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _generateNewQuestionSet() {
    final allCategoryQuestions = List<Map<String, dynamic>>.from(_questionBank[widget.category]!);
    _currentQuestions = [];

    // Select 5 random questions (or all if less than 5 available)
    final questionCount = min(5, allCategoryQuestions.length);
    for (int i = 0; i < questionCount; i++) {
      if (allCategoryQuestions.isEmpty) break;
      final randomIndex = _random.nextInt(allCategoryQuestions.length);
      _currentQuestions.add(allCategoryQuestions.removeAt(randomIndex));
    }
  }

  void _startTimer() {
    _timeLeft = _currentQuestion['timeLimit'];
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer.cancel();
          _answerQuestion(-1); // -1 indicates time expired
        }
      });
    });
  }

  Map<String, dynamic> get _currentQuestion {
    return _currentQuestions[_currentQuestionIndex];
  }

  void _answerQuestion(int selectedAnswer) {
    _timer.cancel();

    if (selectedAnswer == _currentQuestion['correctAnswer']) {
      setState(() {
        _score++;
      });
    }

    if (_currentQuestionIndex < _currentQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _startTimer();
    } else {
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
    });
    _generateNewQuestionSet();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Text(
                '$_score',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _quizCompleted
          ? _buildResultsScreen(context)
          : _buildQuestionScreen(context),
    );
  }

  Widget _buildResultsScreen(BuildContext context) {
    final totalQuestions = _currentQuestions.length;
    final percentage = (_score / totalQuestions * 100).round();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Completed!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: 10,
              backgroundColor: Colors.grey[800],
              color: _getScoreColor(percentage),
              semanticsLabel: 'Progress',
            ),
            const SizedBox(height: 20),
            Text(
              'Your Score: $_score/$totalQuestions ($percentage%)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text(
              _getScoreMessage(percentage),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            FilledButton(
              onPressed: _resetQuiz,
              child: const Text('New Quiz'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Choose Another Category'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  String _getScoreMessage(int percentage) {
    if (percentage >= 80) return 'Excellent! You really know your stuff!';
    if (percentage >= 50) return 'Good job! You can do even better!';
    return 'Keep practicing! You\'ll improve!';
  }

  Widget _buildQuestionScreen(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _currentQuestions.length,
              backgroundColor: Colors.grey[800],
              color: Theme.of(context).colorScheme.primary,
              minHeight: 10,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1}/${_currentQuestions.length}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _timeLeft <= 5
                        ? Colors.red.withOpacity(0.3)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$_timeLeft s',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _timeLeft <= 5 ? Colors.red : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_currentQuestion['image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _currentQuestion['image'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.broken_image),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            Text(
              _currentQuestion['question'],
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...List.generate(
              _currentQuestion['answers'].length,
                  (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _answerQuestion(index),
                  child: Text(
                    _currentQuestion['answers'][index],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}