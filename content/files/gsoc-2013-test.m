function t = check_performance (foo, loops, im, se)
  try
    t = cputime ();
    for i = 1:loops
      foo (im, se);
    endfor
    t = cputime () -t;
    printf ("Cputime: %f\n", t/loops);
  catch
    printf ("Computer says NO!\n");
    t = 0;
  end_try_catch
endfunction

function check_all (loops, im, se)
  printf ("Checking imerode from image package v2.0.0\n");
  old = check_performance (@imerode_2, loops, im, se);
  printf ("Checking imerode from development version (6db5e3c6759b)\n");
  dev = check_performance (@imerode_dev, loops, im, se);
  printf ("Checking new version of imerode\n");
  new = check_performance (@imerode, loops, im, se);
  if (old != 0)
    increase2old = old/new
  endif
  if (dev != 0)
    increase2dev = dev/new
  endif
endfunction

se = logical ([0 1 0; 1 1 1; 0 1 0]);
## binary 2d 0.9
im = rand (500) < 0.9;
printf ("Testing 100X with 2D binary random 90 true pixels\n")
check_all (100, im, se);

## binary 2d 0.1
printf ("Testing 100X with 2D binary random 10 true pixels\n")
im = rand (500) < 0.1;
check_all (100,im, se);

## binary 3d + 2d se
printf ("Testing 100X with 3D binary random image but 2D SE\n")
im = rand (200, 200, 100) > 0.5;
check_all (100, im, se);

## binary 3d + 3d se
printf ("Testing 50X with 3D binary random image but 3D SE\n")
se = rand (3,3,3) > 0.5;
im = rand (200, 200, 100) > 0.5;
check_all (50, im, se);

## binary 7d
printf ("Testing 5X with 7D binary random and 5D SE\n")
se = rand (ones (5, 1) * 3) > 0.5;
im = rand (ones (7, 1) * 10) > 0.5;
check_all (5, im, se);

## grayscale 2d
se = [0 1 0; 1 1 1; 0 1 0];
printf ("Testing 100X with 2D uint8 image\n")
im = randi (255, 500, "uint8");
check_all (100, im, uint8 (se));

## grayscale 3d
printf ("Testing 50X with 3D uint8 image and 2D SE\n")
im = randi (255, 200, 200, 100, "uint8");
check_all (50, im, uint8 (se));

## grayscale 3d
printf ("Testing 50X with 3D uint8 image and 3D SE\n")
se = rand (3, 3, 3) > 0.5;
check_all (50, im, uint8 (se));

## grayscale 7d
printf ("Testing 10X with 7D uint8 image and 3D SE\n")
im = randi (255, ones (7, 1) * 10, "uint8");
check_all (10, im, uint8 (se));

## grayscale 7d
se = rand (3, 3, 1, 1 ,3, 1, 3) > 0.5;
printf ("Testing 10X with 7D uint8 image and 7D SE\n")
im = randi (255, ones (7, 1) * 8, "uint8");
check_all (10, im, uint8 (se));

## grayscale 2D with much larger SE
se = rand (10) > 0.3;
printf ("Testing 100X with 2D uint8 image and larger SE\n")
im = randi (255, 500, "uint8");
check_all (100, im, uint8 (se));
