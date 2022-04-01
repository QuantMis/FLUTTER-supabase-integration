import 'package:flutter/material.dart';
import 'app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://jdltijcjywqurmmvneft.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpkbHRpamNqeXdxdXJtbXZuZWZ0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDg3ODA2NTAsImV4cCI6MTk2NDM1NjY1MH0.-FNQPZYu6QZBDNW3Md5rtd_0Zlt61sI2UEg10snNRjI',
      debug: true);
  runApp(const App());
}
