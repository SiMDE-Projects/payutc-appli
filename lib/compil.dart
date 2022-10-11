import 'package:logger/logger.dart';
import 'package:logger_flutter_viewer/logger_flutter_viewer.dart';

const bool showLogConsole = false;

//logger
class ScreenOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    LogConsole.output(event);
  }
}

final Logger logger = Logger(
  printer: PrettyPrinter(),
  output: ScreenOutput()
);