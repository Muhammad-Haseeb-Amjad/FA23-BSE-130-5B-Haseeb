import 'dart:convert';
import 'dart:io';

class Student{
  String name;
  int age;
  String city;
  List<String>Hobbies;
  Set<String>Subject;
  Student(this.name,this.age,this.city,this.Hobbies,this.Subject);
  void showinfo(){
    print("Name:$name ");
    print("Age:$age");
    print("City:$city");
    print("Hobbies$Hobbies");
  print("Subject$Subject");
}
 Map <String,dynamic> toMap(){
return{
  'name':name,
  'age':age,
  'city':city,
  'Hobbies':Hobbies,
  'Subject':Subject.toList(),
  };
  }
}
void main(){
  List<Student> student=[];
  while(true){
    print("-------Student Menu---------");
    print("1.Add Student");
    print("2.Show Student");
    print("3.Search student");
    print("4.Export Data as JSON");
    print("5. Filter Subjects or Hobbies");
    print("6.Exit");


    stdout.write("Enter Your Choice: ");
    String? choice=stdin.readLineSync();

    switch(choice){
      case '1':
        stdout.write("Enter Your Name: ");
        String name=stdin.readLineSync()??"";

        int age;
        while(true){
          stdout.write("Enter Your Age: ");
          try{
            age=int.parse(stdin.readLineSync()!);
            break;
          } catch(e){
            print("Invalid input. Enter Only Integers");
          }
        }
        stdout.write("Enter Your City: ");
        String city=stdin.readLineSync()??"";

        stdout.write("Enter Your Hobbies with comma: ");
        List<String> Hobbies=(stdin.readLineSync()??"").split(",").map((e)=>e.trim()).toList();

        stdout.write("Enter Your Subject with comma: ");
        Set<String> Subject=(stdin.readLineSync()??"").split(",").map((e)=>e.trim()).toSet();

        student.add(Student(name,age,city,Hobbies,Subject));
        print("Student Data Add Successfully!");
        break;
      case '2':
        if(student.isEmpty){
          print("Student data are not found");
        }
        else{
          for(var s in student){
            s.showinfo();
            print("-------------------");
          }
        }
        break;
      case'3':
        stdout.write("Enter name to Search:");
        String searchname=stdin.readLineSync()??"";
        var found=student.where((s)=>s.name.toLowerCase()==searchname.toLowerCase());
        if(found.isEmpty){
          print("Student are not found");
        }
        else{
          print("Student found:");
          found.first.showinfo();
        }
        break;
      case'4':
        if(student.isEmpty){
          print("No Student to export");
        }
        else{
          List<Map<String,dynamic>>data=student.map((s)=>s.toMap()).toList();
          String jsonData=jsonEncode(data);
          print("Exported JSON Data:\n$jsonData");

        }
        break;
      case'5':
        if(student.isEmpty){
          print("Student are not Available");
        }
        else{
          stdout.write("Enter key to filter(Hobby/Subject):");
          String Keyword=stdin.readLineSync()??"";
          var filtered=student.where((s)=> s.Hobbies.contains(Keyword)||s.Subject.contains(Keyword));
          if(filtered.isEmpty){
            print("No Matched");
          }
          else{
            print("Filtered Students:");
            for(var s in filtered){
              s.showinfo();
              print("--------------------");
            }
          }
        }
        break;
      case'6':
        print("Exiting Program...");
        return;
      default:
        print("Invalid choice, Try again");
    }

  }
}








//  void main(){
//   String name="Haseeb";
//   int age=22;
//   String city="Vehari";
//   print("Wellcome $name from $city!");
//   if(age>=18){
//     print("You are eligible to register");
//   }
//   else {
//     print("You must be 18+ to register");
//   }
//   List <String> Hobies=['Reading','Coding','Learning'];
//   print(Hobies);
//   Set <String> Subject={'Math','islamiyat','Science'};
//   print(Subject);
//   Map <String,dynamic> student={
//     'name':name,
//     'age':age,
//     'city':city,
//   };
//   print(student['name''age''city']);
//   void greet(String name){
//     print("hello $name!");
//    }
//    int square(int x)=>x*x;
//   greet(name);
//   print("Your age squared is: ${square(age)}");
// }