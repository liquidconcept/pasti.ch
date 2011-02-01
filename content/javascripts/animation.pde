/* @pjs transparent=true; */

int canvas_width = 950;
int canvas_height = 700;

int bubbles_right_pos = 153;
int bubbles_bottom_pos = 175;

PShape factory;
PShape bubbles_base;
Bubble[] bubbles = new Bubble[5 * 13];

int start_color = color(140, 139, 132);

int animation_duration = 60000;
int animation_start = 2000;

void setup()
{
  size(canvas_width, canvas_height);
  colorMode(RGB);
  frameRate(30);

  // load images
  factory = loadShape("/images/animation/factory.svg");
  
  bubbles_base = loadShape("/images/animation/bubbles-base.svg"); // 392x297
  bubbles_base.disableStyle();

  for (int j = 0 ; j < 5 ; j++)
  {
    for (int i = 0 ; i < 13 ; i++)
    {
      if ( j < 4 || (j < 5 && i > 4) || (i > 9 && i < 11))
      {
        bubbles[i + j * 13] = new Bubble(int(random(510, 680)), int(random(260, 300)), 60 * (i + 1), 60 * (j + 1) - 25, loadShape("/images/animation/bubble-" + str(int(random(1, 4))) + ".svg"), animation_duration); // 189x168
      }
    }
  }

  smooth();
}

void draw()
{
  // position bubbles
  for (int i = 0 ; i < bubbles.length ; i++)
  {
    if (bubbles[i] && millis() > animation_start)
    {
      bubbles[i].move();
    }
  }
  
  // styles
  background(0, 0, 0, 0);
  noStroke();
  if (over() && !complete)
  {
    $('canvas').css('cursor', 'pointer');
  }
  else
  {
    fill(start_color);
    $('canvas').css('cursor', 'auto');
  }

  // draw factory
  shape(factory, canvas_width - factory.width, canvas_height - factory.height);
  
  // draw cloud
  shape(bubbles_base, canvas_width - bubbles_right_pos - bubbles_base.width, canvas_height - bubbles_bottom_pos - bubbles_base.height);
  boolean complete = true;
  for (int i = 0 ; i < bubbles.length ; i++)
  {
    if (bubbles[i])
    {
      bubbles[i].display();
      if (complete)
      {
        complete = bubbles[i].complete;
      }
    }
  }
  
  if (complete)
  {
    $('canvas').css('cursor', 'auto');
    noLoop();
  }

  if ($('#illustration').is(':hidden'))
  {
    animation_start += millis();
    $('#illustration').fadeIn(800);
  }
}

boolean over()
{
  if (mouseX >= canvas_width - bubbles_right_pos - bubbles_base.width && mouseX <= canvas_width - bubbles_right_pos &&
      mouseY >= canvas_height - bubbles_bottom_pos - bubbles_base.height && mouseY <= canvas_height - bubbles_bottom_pos)
  {
    return true;
  }
  for (int i = 0 ; i < bubbles.length ; i++)
  {
    if (bubbles[i] && bubbles[i].over())
    {
      return true;
    }
  }
  return false;
}

void mouseClicked()
{
  if (over())
  {
    for (int i = 0 ; i < bubbles.length ; i++)
    {
      if (bubbles[i])
      {
        bubbles[i].duration(2500, 0);
      }
    }
  }
}

class Bubble
{
  PShape bubble; // bubble image

  int width = 100;    //
  int height = 100;   //
  int x;              // current x position
  int y;              // current y position
  int xend;           // x position on animation end
  int yend;           // y position on animation end
  int xdir;           // x direction from start to end (positive for left to right)
  int ydir;           // y direction from start to end (positive for top to bottom)

  int dx;
  int dy;
  int incr;

  int steps;     // number of step (pixel) to complet move
  
  boolean complete = false; // true if animation completed

  int animation_duration = 0;
  float step_duration = 0.0;
  int remaining_step_duration = 0;       // duration from last move

  /*  Bubble object
   *
   *  use Bresenham algorithm to move between town point along a line
   */
  Bubble(int xs, int ys, int xe, int ye, PShape b, int ad)
  {
    bubble = b;
    bubble.disableStyle(); // remove default SVG styles
    
    x = xs;
    y = ys;
    xend = xe;
    yend = ye;

    dx = abs(xend - x); // distance betweean start and end point in x axe
    dy = abs(yend - y); // distance betweean start and end point in y axe

    incr = dx - dy;

    // define direction of movement, used to increment (or decrement) bubble position.
    if (x < xend)
    {
      xdir = 1;
    }
    else
    {
      xdir = -1;
    }

    if (y < yend)
    {
      ydir = 1;
    }
    else
    {
      ydir = -1;
    }

    // define number of step to complete move
    if (dx > dy)
    {
      steps = dx;
    }
    else
    {
      steps = dy;
    }

    // define duration
    duration(ad);
  }

  void duration(int ad, int diff)
  {
    if (typeof(diff) == "undefined")
    {
      diff = 0;
    }

    float new_step_duration = (ad + int(random(-(abs(diff)), abs(diff)))) / steps;
    if (step_duration == 0.0 || new_step_duration < step_duration)
    {
      step_duration = new_step_duration;
    }
  }

  void move()
  {
    if (complete)
    {
      return;
    }
    
    if (animation_duration == 0)
    {
      animation_duration = millis();
      remaining_step_duration = 0;
    }
    else
    {
      int duration = millis() - animation_duration;
      animation_duration += duration;
      remaining_step_duration += duration;
    }

    while (remaining_step_duration >= step_duration)
    {
      if (steps > 0)
      {
        int incr2 = 2 * incr;

        if (incr2 > -(dy))
        {
          incr -= dy;
          x += xdir;
        }
        if (incr2 < dx )
        {
          incr += dx;
          y += ydir;
        }

        steps--;
      }
      
      if (steps == 0)
      {
        complete = true;
        return;
      }
      
      remaining_step_duration -= step_duration;
    }
  }

  void display()
  {
    shape(bubble, x, y, width, height);
  }

  boolean over()
  {
    if (mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height)
    {
      return true;
    }
    return false;
  }
}

