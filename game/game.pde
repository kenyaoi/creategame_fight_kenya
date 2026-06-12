int x=0, y=0;//マウスクリック時など使用
int gamestart=0;//画面切り替え用
/*目次
gamestart=0
 スタート画面
gamestart=1
　スタート時カウントダウン
gamestart=2
　ゲーム中～ゲーム終了文字まで
gamestart=3
  ランキング表示
*/


//時間カウント用
int start_time,passed_time;//総合時間管理用
int start_countdown=0,countdown;//カウントダウンを記録
int gamefin_count;//ゲーム終了時カウント用


//得点カウント用
int point_total=0;
int point_minus=0;
int point_plus=0;

//矢インジケーター
int me_arrow_count=5;
int me_arrow_time;

//攻撃矢
int me_arrow_x;
int me_arrow_y=400;
int me_arrow_minus=0;
int me_arrow=0;//攻撃中かどうか

//自分の位置管理
int me_x=150;
int me_y=400;//不変

//キーボード管理（キーを押したときに反応しすぎるため）
int key_count=10;

//敵
int arrow_x[] = new int[15];//矢
int arrow_y[] = new int[15];//矢
int arrow_y_plus[] = new int[15];//矢をy方向に進めるためのもの
int sword_x[] = new int[10];//剣
int sword_y[] = new int[10];//剣
int sword_y_plus[] = new int[10];//剣をy方向に進めるためのもの
int random_value1;
int random_value2;
int i=0;//敵識別
int h=0;//敵識別
int j;//タイミング管理
int k;//タイミング管理

//画像読込み
PImage arrow_down,arrow_up,sword_down,me,arrow_me;

//得点記録
int point[]=new int[5];
int point_recorded=0;
int point_array;
int point_min;//得点がランクインしたときにランキング最下位と入れ替える合図
int p;//ポイントの配列を数えるときに使用

void setup(){
  size(400, 600);
  background(#D1CFCF);
  PFont font = createFont("Meiryo", 50);
  textFont(font);
  
  arrow_down = loadImage( "arrow_down.png" );
  arrow_up = loadImage( "arrow_up.png" );
  sword_down = loadImage( "sword.png" );
  me = loadImage( "me.png" );
  arrow_me = loadImage( "arrow_me.png" );
  
  //ゲーム説明
  fill(#0000FF);
  textSize(20);
  image(sword_down,10,5);
  text("・敵はどんどん攻めてきます。", 60, 40);
  text("自分の陣地まで攻められたら－5P。", 10, 75);
  image(me,10,80);
  text("　但し この敵とは対面することで", 60, 115);
  text("戦って勝つことができます。(＋15P)", 10, 150);
  fill(#FFB003);
  text("・移動は下の枠にある矢印をクリックする", 10, 185);
  text("とできます。矢印キーでも移動可能です。", 10, 220);
  image(arrow_down,10,225);
  fill(#FF0000);
  text("・矢もとんできます。当たってしまう", 60, 255);
  text("と－10Pです。但し、こちらから矢を", 10, 290);
  text("とばすこともでき、矢同士がぶつかれば", 10, 325);
  text("＋100P。矢は右下の赤い矢のマークを", 10, 360);
  text("クリックでとばせます。(SPACEキーも可)", 10, 395);
  text("発射後5秒で上の矢インジケーターがたまっ", 10, 430);
  text("て、また新たに発射できるようになります。", 10, 465);
  textSize(18);
  text("※敵に当たると＋10Pです。", 10, 490);
  
  //スタートボタン（x:50～350、y:500～570）
  fill(#FFFFFF);
  rect(50, 500, 300, 70, 30);
  fill(0);//スタート文字
  textSize(50);
  text("スタート", 100, 555);
  
  fill(0);//スペースキースタート文字
  textSize(20);
  text("SPACEキーでもスタートできます。", 50, 590);
  
  start_time=millis();//時間を記録
  
}


void draw(){
  passed_time=millis()-start_time;//このProcessing実行後の経過時間
  
  
  if(gamestart==0){//スタート画面、スタートボタンを押すとゲームスタート
    if((x>=50)&&(x<=350)&&(y>=500)&&(y<=570)) gamestart=1;//スタートボタンクリック
    if((keyPressed == true) && (key == ' ')) gamestart=1;//スペースキーでもスタート
    x=0;
    y=0;
    
    //得点履歴記録（全部0）
        for(int p = 0; p<= 4; p++){
          point[p]=0;
        }
  
    
  }//スタート画面終了
  
  
  
  
  if(gamestart==1){//ゲームスタートカウントダウン中
    if(start_countdown==0){//if(gamestart==1)のループ1回目の場合
      start_countdown=passed_time;
      countdown=3;//スタート時のカウントダウンを3秒に設定
      
      
        //敵の動きをこのタイミングで作る
        for(int i = 0; i <= 14; i++){
          random_value1=(int)(random(0,7.99));
          arrow_x[i]=random_value1*50;
          arrow_y[i]=0;
          arrow_y_plus[i]=0;
        }
        for(int i = 0; i <= 9; i++){
          random_value2=(int)(random(0,7.99));
          if((random_value1==random_value2)&&(random_value1>=4)) random_value2=random_value2/2;
          if((random_value1==random_value2)&&(random_value1<4)) random_value2=random_value2*2;
          sword_x[i]=random_value2*50;
          sword_y[i]=0;
          sword_y_plus[i]=0;
        }
        
    }//if(start_countdown==0)の閉じ
    
    
    background(#D1CFCF);
    fill(0);//数字文字
    textSize(100);
    text(countdown, 167, 300);
    
    if(passed_time-start_countdown>=1*1000){//1秒経ったらカウントダウンを1秒マイナス
      countdown--;
      start_countdown=passed_time;
    }
    
    if(countdown==0){//カウントダウンが0になったら次（gamestart=2)へ
      gamestart=2;
      start_countdown=0;
      countdown=30;//ゲームの制限時間を30秒とする
      j=countdown;//敵を出すタイミングで使う
      k=countdown;//敵を出すタイミングで使う
      gamefin_count=0;
      point_total=0;
      point_recorded=0;
      point_min=0;
    }
    
  }//ゲームスタートカウントダウン終了
  
  
  
  
  if(gamestart==2){//ゲーム中
    background(#D1CFCF);
    
    //インジケーター回復
    if((me_arrow_count<=4)&&(passed_time-me_arrow_time>=1*1000)){
      me_arrow_count++;
      me_arrow_time=passed_time;
    }
     
    //攻撃矢判定
    if((me_arrow==1)&&(me_arrow_y<=0)){
      me_arrow=0;
      me_arrow_y=400;
    }
    
     //攻撃矢
    if(me_arrow==1){
      me_arrow_y=me_arrow_y-me_arrow_minus;
      image( arrow_up,me_arrow_x,me_arrow_y);
      
      for(int i=0; i<15; i++){
        if ((me_arrow_x==arrow_x[i])&&(me_arrow_y-50-arrow_y[i]<=0)){
          me_arrow_minus=0;
          me_arrow_y=400;
          me_arrow=0;
          arrow_y_plus[i]=0;
          arrow_y[i]=0;
          point_plus=point_plus+100;}//プラスぽいんと
      }
      for(int h=0; h<10; h++){
        if ((me_arrow_x==sword_x[h])&&(me_arrow_y-50-sword_y[h]<=0)){
          me_arrow_minus=0;
          me_arrow_y=400;
          me_arrow=0;
          sword_y_plus[h]=0;
          sword_y[h]=0;
          point_plus=point_plus+10;}//プラスぽいんと
      }
      
      if(me_arrow_y<=70){
        me_arrow_minus=0;
        me_arrow_y=400;
        me_arrow=0;
      }
    }
    
    //自分の位置操作
    if((x>=20)&&(x<=110)&&(y>=480)&&(y<=570)&&(countdown!=0)) me_x=me_x-50;//←ボタンクリック
    if((x>=130)&&(x<=220)&&(y>=480)&&(y<=570)&&(countdown!=0)) me_x=me_x+50;//→ボタンクリック
    if((x>=260)&&(x<=380)&&(y>=480)&&(y<=570)&&(countdown!=0)&&(me_arrow_count==5)){//攻撃ボタンクリック
      me_arrow_count=0;
      me_arrow_time=passed_time;
      me_arrow=1;
      me_arrow_minus=3;
      me_arrow_x=me_x;
    }
      
    if((keyPressed == true)&&(key_count>=10)){ 
      if((keyCode == LEFT)&&(countdown!=0)) me_x=me_x-50;//←キー押下
      if((keyCode == RIGHT)&&(countdown!=0)) me_x=me_x+50;//→キー押下
      if((key == ' ')&&(countdown!=0)&&(me_arrow_count==5)){//スペースキー（攻撃）押下
        me_arrow_count=0;
        me_arrow_time=passed_time;
        me_arrow=1;
        me_arrow_minus=3;
        me_arrow_x=me_x;}
      key_count=0;
    }
    key_count++;//キーボードの反応が良すぎるための微調整
    
    
    
      
    
    
    
    //左端、右端ではみ出さないように修正
    if(me_x<=-50) me_x=0;
    if(me_x>=400) me_x=350;
    
    //自分の位置
    fill(#FFFFFF);
    stroke(0);
    image( me,me_x,me_y);
    
    //敵どんどん排出（矢）
    for(int a=0; a<15; a++){
    image( arrow_down,arrow_x[a],arrow_y[a]);
    }
    
    if((j==countdown)&&(countdown!=0)){//2秒に1回矢を放つ
      arrow_y_plus[i]=3;
      i++;
      j=j-2;}
      
    if(countdown==0){//ゲーム終了時動きをとめる
      for(int a=0; a<15; a++) arrow_y_plus[a]=0;
    }
    
    for(int a=0; a<15; a++){//矢を動かす
    arrow_y[a]=arrow_y[a]+arrow_y_plus[a];
    }
    
    for(int i=0; i<15; i++){ 
      if((arrow_y[i]>=350)&&(arrow_x[i]==me_x)){//矢が自分に当たったら
        point_minus=point_minus+10;//マイナスぽいんと
        arrow_y_plus[i]=0;
        arrow_y[i]=0;
       }
       if(arrow_y[i]>=448){//矢が当たらず通過したら
        arrow_y_plus[i]=0;
        arrow_y[i]=0;
       }
    }
    
    //敵どんどん排出（剣）
    for(int a=0; a<10; a++){
    image( sword_down,sword_x[a],sword_y[a]);
    }
    
    if((k==countdown)&&(countdown!=0)){//3秒に1回剣を放つ
      sword_y_plus[h]=2;
      h++;
      k=k-3;}
      
    if(countdown==0){
      for(int a=0; a<10; a++) sword_y_plus[a]=0;
    }
    
    for(int a=0; a<10; a++){//剣を動かす
    sword_y[a]=sword_y[a]+sword_y_plus[a];
    }
    
    for(int h=0; h<10; h++){
      if((sword_y[h]>=350)&&(sword_y[h]<440)&&(sword_x[h]==me_x)){
        point_plus=point_plus+15;//プラスぽいんと
        sword_y_plus[h]=0;
        sword_y[h]=0;
      }else if(sword_y[h]>=448){
        point_minus=point_minus+5;//マイナスぽいんと
        sword_y_plus[h]=0;
        sword_y[h]=0;
      }
    }

    
    
    point_total=point_total+point_plus-point_minus;//得点計算
    point_plus=0;
    point_minus=0;
    
    //★★★60秒カウントダウン関連,上の枠関連↓
    fill(0);
    noStroke();
    rect(0,0,400,70);//上の黒枠
    
    fill(0);
    stroke(#FFFFFF);
    strokeWeight(3);
    rect(0,0,60,70);//カウントダウン枠線
    
    fill(#FFFFFF);//カウントダウン文字
    textSize(20);
    text("残り", 10, 25);
    textSize(30);
    text(countdown, 10, 60);//カウントダウン
    
    
    fill(0);
    stroke(#FFFFFF);
    strokeWeight(3);
    rect(60,0,250,70);//インジケーター枠線
    
    fill(#FFFFFF);//インジケーター文字
    textSize(20);
    text("矢インジケーター", 105, 25);
    
    //インジケーター関連↓
    
      fill(#B4B4B4);
      stroke(#DAD7E8);
      strokeWeight(2);
      rect(82,32,39,30);//1
      rect(123,32,39,30);//2
      rect(164,32,39,30);//3
      rect(205,32,39,30);//4
      rect(246,32,39,30);//5
    //攻撃時インジケーターを0にする
    if(me_arrow_count==1){
      fill(#FCF21F);
      stroke(#DAD7E8);
      strokeWeight(2);
      rect(82,32,39,30);//1
    }else if(me_arrow_count==2){
      fill(#FCD81F);
      stroke(#DAD7E8);
      strokeWeight(2);
      rect(82,32,39,30);//1
      rect(123,32,39,30);//2
    }else if(me_arrow_count==3){
      fill(#FCC91F);
      stroke(#DAD7E8);
      strokeWeight(2);
      rect(82,32,39,30);//1
      rect(123,32,39,30);//2
      rect(164,32,39,30);//3
    }else if(me_arrow_count==4){
      fill(#FCA81F);
      stroke(#DAD7E8);
      strokeWeight(2);
      rect(82,32,39,30);//1
      rect(123,32,39,30);//2
      rect(164,32,39,30);//3
      rect(205,32,39,30);//4
    }else if(me_arrow_count==5){
      fill(#FF0000);
      stroke(#DAD7E8);
      strokeWeight(2);
      rect(82,32,39,30);//1
      rect(123,32,39,30);//2
      rect(164,32,39,30);//3
      rect(205,32,39,30);//4
      rect(246,32,39,30);//5
    }//インジケーター回復時の表示
    
    
    
    fill(0);
    stroke(#FFFFFF);
    strokeWeight(3);
    rect(310,0,89,70);//得点枠線
    
    fill(#FFFFFF);//得点文字
    textSize(20);
    text("得点", 335, 25);
    textSize(30);
    text(point_total, 330, 60);//得点
    //★★★60秒カウントダウン関連↑
    
    //下の枠関連★★★↓
    fill(0);
    noStroke();
    rect(0,450,400,150);//下の黒枠
    
    fill(#2100FF);
    stroke(#FFFFFF);
    strokeWeight(5);
    rect(20,480,90,90,15);//左枠
    
    fill(#FFFFFF);//←文字
    textSize(50);
    text("←", 40, 542);
    
    
    fill(#2100FF);
    stroke(#FFFFFF);
    strokeWeight(5);
    rect(130,480,90,90,15);//右枠
    
    fill(#FFFFFF);//→文字
    textSize(50);
    text("→", 150, 542);
    
    
    fill(#FF0000);
    stroke(#FFFFFF);
    strokeWeight(5);
    rect(260,480,120,90,15);//攻撃枠
    image(arrow_me,265,485);
    
    //xとyをリセット
    x=0;
    y=0;
    
    //下の枠関連★★★↑
    
    
    if(gamefin_count>=1){//カウントダウンが0になった時終了文字表示
      fill(0);
      noStroke();
      rect(0, 260, 400, 60);
      fill(#FFFFFF);//終了文字
      textSize(30);
      text("ゲーム終了", 120, 300);
      
      
      
      if(gamefin_count==4){//ゲーム終了後3秒経ったら次（gamestart=3)へ
        gamestart=3;
        start_countdown=0;
        
        for(int p = 0; p<= 4; p++){
          if((point[p]==0)&&(point_recorded==0)){//0の得点（デフォルト）を今回の得点に塗り替える
          point[p]=point_total;
          point_recorded=1;
          }
          if((point[4]<=point_total)&&(point_recorded==0)){//ランクインの場合
          point_min=1;
          point_recorded=1;
          }
        }//for(int p = 0; i <= 4; p++)の最後
        
        if(point_min==1){//得点がランクインした場合
          point[4]=point_total;
        }
        
        for(int q=0; q<=3; q++){//得点並び替え
           for(int r=q+1; r<=4; r++){
            if(point[q]<point[r]){
              point_array=point[r];
              point[r]=point[q];
              point[q]=point_array;}
            }
           }
           
      }//if(gamefin_count==4)の最後
      
    }//if(gamefin_count>=1)の最後
    
    if(start_countdown==0){//if(gamestart==2)のループ1回目の場合
      start_countdown=passed_time;
    }
    
    if(passed_time-start_countdown>=1*1000){//1秒経ったらカウントダウンを1秒マイナス
      countdown--;
      start_countdown=passed_time;
      if(countdown<=0){
        gamefin_count++;//ゲーム終了時（0になったとき）カウントを開始
        countdown=0;}
    }
    
  }//ゲーム中画面終了
  
  
  
  
  if(gamestart==3){
    background(#D1CFCF);//今回得点枠
    fill(0);
    noStroke();
    rect(100,50,200,100);
    
    fill(#FFFFFF);//今回得点文字
    textSize(60);
    text(point_total, 145, 120);
    
    fill(#D1CFCF);//ランキング枠
    stroke(0);
    strokeWeight(2);
    rect(70,170,260,70);
    rect(70,240,260,70);
    rect(70,310,260,70);
    rect(70,380,260,70);
    rect(70,450,260,70);
    line(140,170,140,520);
    
    fill(0);//ランキング順位文字
    textSize(40);
    text("1",95,220);
    text("2",95,290);
    text("3",95,360);
    text("4",95,430);
    text("5",95,500);
    text(point[0],190,220);//得点一覧
    text(point[1],190,290);
    text(point[2],190,360);
    text(point[3],190,430);
    text(point[4],190,500);
    
    fill(#FF0000);//再プレイ枠・文字
    stroke(0);
    strokeWeight(5);
    rect(40,530,320,60);
    fill(0);
    textSize(40);
    text("もう1回PLAY",80,575);
    
    if((x>=40)&&(x<=360)&&(y>=530)&&(y<=590)) gamestart=1;//リスタート
    if((keyPressed == true) && (key == ' ')) gamestart=1;//スペースキーでもスタート
    x=0;
    y=0;
    start_countdown=0;
    i=0;
    h=0;
  }
  
  
}

void mousePressed(){
 x=mouseX;
 y=mouseY;
}
