import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(HajjTestApp());

class HajjTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الحاج يقيسك',
      theme: ThemeData.dark().copyWith(primaryColor: Colors.teal),
      home: QuizScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Question {
  final String text;
  final List<String> options;
  final int correctIndex;
  Question(this.text, this.options, this.correctIndex);
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _qIndex = 0;
  int _score = 0;
  int _seconds = 30;
  Timer? _timer;
  bool _answered = false;

  final List<Question> _questions = [
    Question('1. الماوس يعتبر شنو؟', ['جهاز إدخال', 'جهاز إخراج', 'وحدة تخزين', 'معالج'], 0),
    Question('2. اختصار النسخ على الكيبورد؟', ['Ctrl+V', 'Ctrl+C', 'Ctrl+X', 'Ctrl+Z'], 1),
    Question('3. RAM اختصار لـ؟', ['ذاكرة دائمة', 'ذاكرة الوصول العشوائي', 'بطاقة رسومية', 'قرص صلب'], 1),
    Question('4. شنو هو نظام التشغيل؟', ['Microsoft Word', 'Windows', 'Google Chrome', 'Photoshop'], 1),
    Question('5. امتداد ملف الصورة؟', ['.docx', '.mp3', '.jpg', '.exe'], 2),
    Question('6. CPU هي؟', ['الذاكرة', 'وحدة المعالجة المركزية', 'الشاشة', 'الماوس'], 1),
    Question('7. شنو البخزن الملفات دايماً؟', ['RAM', 'SSD/HDD', 'الكاش', 'البطارية'], 1),
    Question('8. الانترنت هو؟', ['برنامج', 'شبكة عالمية', 'ملف', 'طابعة'], 1),
    Question('9. Ctrl+Z بعمل شنو؟', ['لصق', 'قص', 'تراجع', 'حفظ'], 2),
    Question('10. المتصفح هو؟', ['Chrome, Firefox', 'Excel, Word', 'Windows', 'Antivirus'], 0),
    Question('11. 1GB = كم MB؟', ['100', '1000', '1024', '512'], 2),
    Question('12. الفيروس هو؟', ['برنامج ضار', 'قطعة هاردوير', 'نوع ملف', 'متصفح'], 0),
    Question('13. البريد الإلكتروني اسمو؟', ['Email', 'SMS', 'URL', 'PDF'], 0),
    Question('14. شنو معنى PDF؟', ['Portable Document Format', 'Personal Data File', 'Print Doc Format', 'Program Data File'], 0),
    Question('15. وايفاي WiFi شنو؟', ['كيبل نت', 'شبكة لاسلكية', 'برنامج', 'معالج'], 1),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _seconds = 30;
    _answered = false;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0 &&!_answered) {
        setState(() => _seconds--);
      } else {
        _timer?.cancel();
        if (!_answered) _nextQuestion(); // الزمن انتهى = غلط
      }
    });
  }

  void _answer(int selectedIndex) {
    if (_answered) return;
    _answered = true;
    _timer?.cancel();
    if (selectedIndex == _questions[_qIndex].correctIndex) _score++;
    Future.delayed(Duration(milliseconds: 400), _nextQuestion);
  }

  void _nextQuestion() {
    if (_qIndex < _questions.length - 1) {
      setState(() => _qIndex++);
      _startTimer();
    } else {
      _showResult();
    }
  }

  void _showResult() {
    double percent = (_score / _questions.length) * 100;
    String level, plan;

    if (percent <= 40) {
      level = "مبتدئ مبتدئ 🐣";
      plan = "ابدأ بـ: 1. مكونات الكمبيوتر 2. استخدام الماوس والكيبورد 3. كورس ICDL Module 1";
    } else if (percent <= 70) {
      level = "مبتدئ متقدم 💻";
      plan = "ابدأ بـ: 1. ويندوز باحتراف 2. Word + Excel 3. أساسيات الانترنت والأمان";
    } else {
      level = "جاهز للتطور 🚀";
      plan = "انت جاهز لـ: 1. البرمجة Python 2. الشبكات CCNA 3. صيانة الحاسوب A+";
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        title: Text('خلصنا! نتيجتك: ${percent.toStringAsFixed(0)}%'),
        content: Text('المستوى: $level\nخطة البداية:\n$plan'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _qIndex = 0; _score = 0;
                Navigator.pop(context);
                _startTimer();
              });
            },
            child: Text('أعيد الاختبار'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_qIndex];
    double progress = (_qIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('الحاج يقيسك'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(value: progress),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('سؤال ${_qIndex + 1} / ${_questions.length}', style: TextStyle(fontSize: 16)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: _seconds < 10? Colors.red : Colors.teal, borderRadius: BorderRadius.circular(20)),
                  child: Text('$_seconds ثانية', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(q.text, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
           ...List.generate(q.options.length, (i) =>
              Container(
                margin: EdgeInsets.only(bottom: 12),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () => _answer(i),
                  child: Text(q.options[i], style: TextStyle(fontSize: 18)),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
