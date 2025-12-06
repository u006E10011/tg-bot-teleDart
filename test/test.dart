import 'dart:io';

void main(){
  save(stdin.readLineSync()!);
}

void save(String filter) {
  if(filter.isNotEmpty && filter.startsWith("/filter")){
    final text = filter.split("/filter");
    for (var x in text) {
      x.trim();
    }
    print(text[1].trimLeft());
  }
}