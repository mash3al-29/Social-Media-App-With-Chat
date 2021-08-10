void PrintFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

var uID = '';
var uIDmy;
// if(FirebaseAuth.instance.currentUser.emailVerified == false){
// return Padding(
// padding: const EdgeInsets.all(15.0),
// child: Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(20),
// color: Colors.amber.withOpacity(0.6),
// ),
// child: Padding(
// padding: const EdgeInsets.all(15.0),
// child: Row(
// children: [
// Icon(Icons.info_outline),
// SizedBox(width: 10,),
// Expanded(child: Text('Email Not Verified !',style: TextStyle(fontSize: 15),)),
// SizedBox(width: 20,),
// TextButton( onPressed: () {
// FirebaseAuth.instance.currentUser.sendEmailVerification().then((value) {
// DefaultToast(message: 'Email Sent, Check Your Email!', fontsize: 17,Backgroundcolor: Colors.orangeAccent);
// }).catchError((error){
// print(error.toString());
// });
// }, child: Text('SEND!',style: TextStyle(color: Colors.blue),),),
// ],
// ),
// ),
// ),
// );
// }else{
// return Container();
// }