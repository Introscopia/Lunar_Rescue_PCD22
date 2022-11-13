/*
Lunar Rescue
Moon Patrol / dinosauro do chrome
Tron
Missile Command
Frogger
Pulsar
*/

Nave MAE;

Nave[] inimigos;

Nave[] cidades;

Nave player;

PImage chao, astronauta;

int cointoss(){
  float R = random(10);
  if( R > 5 ) return -1;
  else return 1;
}


int FASE = 0;
int PONTOS = 0;

void setup() {
   size(400, 500);
   
   chao = loadImage("chao_lua.png");
   astronauta = loadImage("astronauta.png");
   
   MAE = new Nave( new PVector(50, 10),
                   new PVector( 0.15, 0 ),
                   loadImage( "Nave 2.png" ) );
   //MAE.sprite.resize( 32, 32 );
   
   inimigos = new Nave[8];
   for(int i = 0; i < inimigos.length; i++){
      inimigos[i] = new Nave( new PVector(random(10, 90), 
                              25 + round(random(4))*16 ),
                              new PVector( random(0.1, 0.5)*cointoss(), 0 ),
                              loadImage("inimigo-magenta.png") );
   }
   
   cidades = new Nave[3];
   cidades[0] = new Nave( new PVector( 20, 120 ), new PVector(0,0), null );
   cidades[0].valor = 2;
   cidades[1] = new Nave( new PVector( 50, 120 ), new PVector(0,0), null );
   cidades[1].valor = 1;
   cidades[2] = new Nave( new PVector( 80, 120 ), new PVector(0,0), null );
   cidades[2].valor = 3;
   
   
   player = null;
   
   frameRate(24);
   noSmooth();
   imageMode( CENTER );
   rectMode( CENTER );
   //noStroke();
   stroke(127);
}

void draw() {
  background(#211136);
  scale(4);
  
  image( chao, 50, 117 );
  
  for(int i = 0; i < PONTOS; i++){
     image( astronauta, 92 - 12 * i, 8 );
  }
  
  
  MAE.perambular_x();
  MAE.display();
  
  for(int i = 0; i < inimigos.length; i++){
      inimigos[i].perambular_x();
      inimigos[i].display();
  }
  
  for(int i = 0; i < cidades.length; i++){
     cidades[i].display_valor();
  }
  
  if( player != null ){
    player.voar();
    player.display();
    if( FASE == 0 ){
      for(int i = 0; i < inimigos.length; i++){
         if( player.pos.dist( inimigos[i].pos ) < 8 ){
           player = null;
           break;
         }
      }
      if( player != null ){
        if( player.pos.y + 4 > 96 ){
           for(int i = 0; i < cidades.length; i++){
             if( cidades[i].valor > 0 &&
                 player.pos.y + 4 > (cidades[i].pos.y - cidades[i].valor * 8) &&
                 abs( player.pos.x - cidades[i].pos.x ) < 5 ){
                 
                cidades[i].valor -= 1;
                player.pos.y = (cidades[i].pos.y - cidades[i].valor * 8);
                FASE = 1;
                player.vel.y = 0;
                break;
             }
           }
        }
      }
    }
    if( FASE == 1 ){
      if( player.pos.dist( MAE.pos ) < 8 ){
        PONTOS += 1;
        player = null;
        FASE = 0;
      }
      else if( player.pos.y < 0 ){
        player = null;
        FASE = 0;
      }
    }
  }
   
}

void keyPressed(){
  if( key == ' ' ){
    if( FASE == 0 && player == null ){
      player = new Nave( MAE.pos.get(), new PVector( 0, 0.8 ), loadImage("nave.png") );
    }
    else if( FASE == 1 ){
      player.vel.y = - 0.8;
    }
  }
  
  if( player != null && abs(player.pos.y) > 0 ){ 
    if( keyCode == LEFT ){
      player.vel.x = - 0.6;
    }
    else if( keyCode == RIGHT ){
      player.vel.x = 0.6;
    }
  }
  
}

void keyReleased(){
  if( player != null && abs(player.pos.y) > 0 ){ 
    if( keyCode == LEFT || keyCode == RIGHT ){
      player.vel.x = 0;
    }
  }
}


class Nave{
  PVector pos;
  PVector vel;
  PImage sprite;
  int valor;
  Nave( PVector p, PVector v, PImage s ){
    pos = p;
    vel = v;
    sprite = s;
  }
  
  void perambular_x(){
    pos.add( vel );
    if( pos.x > 90 || pos.x < 10 ) vel.x *= -1;
  }
  void voar(){
    pos.add( vel );
  }
  
  void display(){
    if( sprite == null ){
      rect( pos.x, pos.y, 16, 16 );
    }
    else image( sprite, pos.x, pos.y );
  }
  void display_valor(){
    for(int i = 0; i < valor; i++){
       rect( pos.x, pos.y - i*8, 20, 8 );
    }
  }
}
