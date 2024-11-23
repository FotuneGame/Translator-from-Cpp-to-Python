#include <iostream>
using namespace std;



int n(float v);
bool n3();
int branching();
void cyrcle();
void switch_case();

int* n2(float v2, double v3){
 int message,sas = 1;
 cout << message << "way" << 's' << (1+1);
 std::cout << message;
 cin >> message;
 std::cin >> message >> sas;
 return message;
}



int main(){

 int a,b,ds,s;
 a,b = -2;
 int g = -(a+b);
 float c = +(1.2 * 2 - (12 || 23) + n(2) / 23.4 + 6 % 3);
 char* str = "hello";
 bool* vector = nullptr;

 bool ternar = 2>=2 ? (g+10)==10 : false;

 g = 12;
 g += 1;
 g -= 1;
 g /= 1;
 g *= 1;
 g %= 1;
 g &= 1;
 g ^= 1;
 g |= 1;

 n(1.2);
 n(c);
 int aaa = n2(1.2,c);
 branching();

 return g;
}


int n(float v){
    return (v + 2 / (12 * 12));
}


bool n3(){
    
}


int branching(){
 if(1>2){
    int sas = 1;
    char sis = 's';
    cout << sas;
 }
 
 if(1>2){
    if(2>3){
        int sas = 1;
        if(9 != 0){
            cin >> sas;
        }else{
            cout << sas;
        }
    }
    if(3>4){

    }else if(3>4){

    }else{

    }
 }

 if(true){
    int s;
 }else{
    int a;
 }



 if(100){
    int a;
 }else if (120){
    int a;
 }else if (120){
    if(120 >= 0){
        int a;
    }else if (2){
        if(a){
            int s;
            int ss2;
        }
        int ss1;
    }
 }

 return 23;
}


void cyrcle(){
    int i =10;
    while(i>0){
        int s;
        int b;
        while(i>5){
            if(i){
               break; 
            }else{
                continue;
            }
        }
        i=i-1;
    }
    
    while(2){
        
    }

    for(i,s=0;i<10;i += 1){
        int a;
        double d = 12;
        for(o=1;o && true;o -= i % 2){
            if(!10){
                break;
            }
            continue;
        }
        continue;
    }

    for(j=0;j<10;j = j + 1){
        
    }
    return;
}


void switch_case(){
    int a;
    cin >> a;
    switch(a){
       case (1): break;
       case (2): break;
       case (3):
        a =2;
        break;
       case (4):
        cout << "WOW";
        int s=1;
        break;
      default:
        cout << "Default";
    }

    int b = 2;
    switch(b){
       
    }

    int c = 4;
    switch(c){
       default:
        cout << "C";
        int o = 1;
    }

    int d = 5;
    switch(d){
        case (1):
            switch(c){
                case (2):
                    cout << "lol";
                    break;
            }
            break;
    }
}