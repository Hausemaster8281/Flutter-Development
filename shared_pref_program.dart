void main{
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  return MaterialApp(
  home:
  )
}

class splashscreen extends StatefulWidget{
  @override
createState()=>splashscreenstate();
}

class splashscreenstate extends State{
  void initState(){
    super.init();
    Wheretogo();
  }
  void Wheretogo() async{
    var sharedpref=SharedPreference.getInstance();
    var islogin=await sharedpref.getBool(isLoggedIn);
    Timer(
      Duration(
        seconds:2
      ),
        () {
        if(isLogin!=null)
          {
            if(islogin) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => hOMEpAGE());
              )
            }
            else
              )
            }
          }
        }
    )
    @override
    WIdget build(){
      returnSaffold(
        body: Center(
          child:Text(
            'Zomato'
          )
        )
      );
    }
  }
}