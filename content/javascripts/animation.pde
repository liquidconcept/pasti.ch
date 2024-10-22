/* @pjs transparent=true; */

int canvas_width  = 950;
int canvas_height = 700;

int bubbles_right_pos  = 157;
int bubbles_bottom_pos = 175;

PShape factory;
PShape lever;
PShape bubbles_base;
Bubble[] bubbles = new Bubble[5 * 13];

int start_color   = color(140, 139, 132);
int current_color = color(140, 139, 132);
int end_color     = color(216, 211, 199);

int animation_duration = 60000;
int animation_start    = 2000;

boolean lever_status = false;

boolean clicked = false;

boolean move_complete    = false;
boolean color_complete   = false;
boolean extended         = true;

void setup()
{
  size(canvas_width, canvas_height);
  colorMode(RGB);
  frameRate(30);

  // load images
  factory = loadShape("/images/animation/factory.svg");

  lever = loadShape("/images/animation/lever.svg");
  lever.rotate(-0.3)
  
  bubbles_base = loadShape("/images/animation/bubbles-base.svg"); // 392x297
  bubbles_base.disableStyle();

  for (int j = 0 ; j < 5 ; j++)
  {
    for (int i = 0 ; i < 13 ; i++)
    {
      //if ( j < 4 || (j < 5 && i > 4) || (i > 9 && i < 11))
      if ( j < 3 || (j < 4 && i > 2) || (j < 5 && i > 4) || (i > 9 && i < 11))
      {
        bubbles[i + j * 13] = new Bubble(int(random(510, 680)), int(random(260, 300)), 60 * (i + 1), 60 * (j + 1) - 25, loadShape("/images/animation/bubble-" + str(int(random(1, 4))) + ".svg"), animation_duration); // 189x168
      }
    }
  }

  smooth();
}

void draw()
{
  boolean complete = false;

  // position bubbles
  if (!move_complete)
  {
    for (int i = 0 ; i < bubbles.length ; i++)
    {
      if (bubbles[i] && millis() > animation_start)
      {
        bubbles[i].move();
      }
    }
  }

  // mouse pointer if mouse over cloud
  if ((over_cloud() && (!move_complete || !extended) && !clicked) || over_lever())
  {
    $('#animation').css('cursor', 'pointer');
  }
  else
  {
    $('#animation').css('cursor', 'auto');
  }
  
  // background
  background(0, 0, 0, 0);

  // draw factory
  fill(start_color);
  noStroke();
  shape(factory, canvas_width - factory.width, canvas_height - factory.height);
  display_lever();

  // draw cloud
  if (!move_complete && over_cloud() && !clicked)
  {
    float current_red = red(current_color);
    float current_green = green(current_color);
    float current_blue = blue(current_color);

    fill(color(current_red + 9, current_green + 9, current_blue + 9));
  }
  else if (!move_complete && !color_complete)
  {
    fill(current_color);
  }
  else if (!color_complete)
  {
    complete = true;

    float current_red = red(current_color);
    float current_green = green(current_color);
    float current_blue = blue(current_color);

    if (current_red < red(end_color))
    {
      complete = false;
      current_red += 3;
    }

    if (current_green < green(end_color))
    {
      complete = false;
      current_green += 3;
    }

    if (current_blue < blue(end_color))
    {
      complete = false;
      current_blue += 3;
    }

    current_color = color(current_red, current_green, current_blue);
    fill(current_color);
  }
  else
  {
    fill(current_color);
  }
  noStroke();
  
  shape(bubbles_base, canvas_width - bubbles_right_pos - bubbles_base.width, canvas_height - bubbles_bottom_pos - bubbles_base.height);
  if (!move_complete)
  {
    complete = true;
  }
  for (int i = 0 ; i < bubbles.length ; i++)
  {
    if (bubbles[i])
    {
      bubbles[i].display();
      if (complete && !move_complete)
      {
        complete = bubbles[i].complete;
      }
    }
  }

  // end
  if (complete && !move_complete)
  {
    move_complete = true;
  }
  else if (complete && !color_complete)
  {
    color_complete = true;
    change_lever_status(true);
  }
  else if (extended && move_complete && color_complete && $('#showcase').is(':hidden'))
  {
    $('#showcase').fadeIn(1200, function() { showcase_slide_timeout(true, 'next', 10000) });
  }

  // show animation & reset start timer after first pass
  if ($('#illustration').is(':hidden'))
  {
    animation_start += millis();
    $('#illustration').fadeIn(800);
  }
}

void display_lever()
{
  if (lever_status)
  {
    shape(lever, canvas_width - 84, canvas_height - 66.5);
  }
  else
  {
    shape(lever, canvas_width - 86, canvas_height - 43.5);
  }
}

vois change_lever_status(boolean status)
{
  if (lever_status != status)
  {
    lever_status = status;

    if (lever_status)
    {
      lever.rotate(0.6);
    }
    else
    {
      lever.rotate(-0.6);
    }
  }
}

boolean over_cloud()
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

boolean over_lever()
{
  if (mouseX >= canvas_width - 100 && mouseX <= canvas_width - 30 && mouseY >= canvas_height - 70 && mouseY <= canvas_height - 35)
  {
    return true;
  }
  return false;
}

void mouseClicked()
{
  if (over_cloud() || (over_lever() && !lever_status))
  {
    move_complete  = true;

    for (int i = 0 ; i < bubbles.length ; i++)
    {
      if (bubbles[i])
      {
        if (!extended)
        {
          bubbles[i].direction(bubbles[i].x, bubbles[i].y, bubbles[i].xend, bubbles[i].yend);
        }
        bubbles[i].duration(2500, 50);
      }
    }
    move_complete   = false;
    color_complete  = false;
    clicked         = true;
    extended        = true;
    animation_start = 0;

    change_lever_status(true);
  }
  else if (over_lever() && lever_status)
  {
    move_complete = true;

    for (int i = 0 ; i < bubbles.length ; i++)
    {
      if (bubbles[i])
      {
        bubbles[i].direction(bubbles[i].x, bubbles[i].y, bubbles[i].xstart, bubbles[i].ystart);
        bubbles[i].duration(1500, 50);
      }
    }
    var fade_out = function()
    {
      if($('#slideshow .wrapper').queue().length > 0)
      {
        setTimeout(fade_out, 100);
        return;
      }
      showcase_slide_timeout(false);
      $('#showcase').fadeOut(600, function() { move_complete = false });
    }
    fade_out();
    
    sublimevideo.stop();

    color_complete = true;
    clicked        = false;
    extended       = false;

    change_lever_status(false);
  }
}

class Bubble
{
  PShape bubble; // bubble image

  int width = 100;    //
  int height = 100;   //
  int xstart;         // x position on animation start
  int ystart;         // y position on animation start
  int xend;           // x position on animation end
  int yend;           // y position on animation end
  int x;              // current x position
  int y;              // current y position
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

    xstart = xs;
    ystart = ys;
    xend = xe;
    yend = ye;

    direction(xs, ys, xe, ye);

    duration(ad);
  }

  void direction(int xs, int ys, int xe, int ye, int xc, int yc)
  {
    dx = abs(xe - xs); // distance betweean start and end point in x axe
    dy = abs(ye - ys); // distance betweean start and end point in y axe

    incr = dx - dy;

    // define direction of movement, used to increment (or decrement) bubble position.
    if (xs < xe)
    {
      xdir = 1;
    }
    else
    {
      xdir = -1;
    }

    if (ys < ye)
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

    x = xs;
    y = ys;
    animation_duration = 0;
    complete = false;
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

