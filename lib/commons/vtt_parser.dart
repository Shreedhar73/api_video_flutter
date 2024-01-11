import 'dart:convert';

class VttParser {
  List<Map<String, dynamic>> parseVtt(String vttContent) {
    List<Map<String, dynamic>> cues = [];

    // Split the content into lines
    List<String> lines = LineSplitter.split(vttContent).toList();

    // Initialize variables to store cue information
    String startTime = '';
    String endTime = '';
    List<String> cueText = [];

    // Iterate through lines to parse cues
    for (String line in lines) {
      // Check if the line is a time cue
      if (line.contains(' --> ')) {
        List<String> times = line.split(' --> ');
        startTime = times[0].trim();
        endTime = times[1].trim();
      } else if (line.trim().isEmpty) {
        // Check if the line is empty, indicating the end of a cue
        if (startTime.isNotEmpty && endTime.isNotEmpty && cueText.isNotEmpty) {
          cues.add({
            'startTime': startTime,
            'endTime': endTime,
            'text': cueText.join('\n').trim(),
          });

          // Reset variables for the next cue
          startTime = '';
          endTime = '';
          cueText = [];
        }
      } else {
        // Add non-empty lines to the cue text
        cueText.add(line.trim());
      }
    }

    return cues;
  }
}
