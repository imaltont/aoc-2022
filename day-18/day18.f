      program day18
      implicit none
      integer, dimension(:), allocatable :: x, y, z
      integer, dimension(:,:,:), allocatable :: coords
      integer :: num_lines, io, i, j, k, num_open, num_air
      open(unit=2, file='./resources/input', status='old')
      num_lines = 0
      do 
         read(2,*,iostat=io)
         if(io /= 0) exit
         num_lines = num_lines + 1
      end do
      rewind(2)
      allocate(x(num_lines), y(num_lines), z(num_lines))
      do i = 1,num_lines
         read (2,*) x(i), y(i), z(i)
      end do
      close(2)
C     Padding just to avoid 0-index error on part 2
      do i = 1,num_lines
         x(i) = x(i) + 10
         y(i) = y(i) + 10
         z(i) = z(i) + 10
      end do
      num_open = num_lines * 6
      do i = 1,num_lines
         do j = i+1,num_lines
            if (abs(x(i) - x(j)) + abs(y(i) - y(j)) + abs(z(i) - z(j))
     $           == 1) num_open = num_open - 2
         end do
      end do
      print *, "Part 1: ", num_open

      allocate(coords(maxval(x)+10, maxval(y)+10, maxval(z)+10))
      do i = 1,num_lines
         coords(x(i),y(i),z(i)) = 1
      end do


      do i = 1,maxval(x)+10
         do j = 1,maxval(y)+10
            do k = 1,maxval(z)+10
               if (coords(i, j, k) == 1) then
                  exit;
               endif 
               coords(i, j, k) = 2
            end do
            do k = maxval(z)+10,1,-1
               if (coords(i, j, k) == 1) then
                  exit;
               endif 
               coords(i, j, k) = 2
            end do
         end do
         do j = 1,maxval(z)+10
            do k = 1,maxval(y)+10
               if (coords(i, k, j) == 1) then
                  exit;
               endif 
               coords(i, k, j) = 2
            end do
            do k = maxval(y)+10,1,-1
               if (coords(i, k, j) == 1) then
                  exit;
               endif 
               coords(i, k, j) = 2
            end do
         end do
      end do

C     fill in the ones that the above for some reason doesn't reach
      do i = minval(x),maxval(x)
         do j = minval(y),maxval(y)
            do k = minval(z),maxval(z)
               if (coords(i,j,k) == 0) then
                  if (coords(i-1,j,k) == 2)
     $                 coords(i,j,k) = 2
                  if (coords(i+1,j,k) == 2)
     $                 coords(i,j,k) = 2
                  if (coords(i,j-1,k) == 2)
     $                 coords(i,j,k) = 2
                  if (coords(i,j+1,k) == 2)
     $                 coords(i,j,k) = 2
                  if (coords(i,j,k-1) == 2)
     $                 coords(i,j,k) = 2
                  if (coords(i,j,k+1) == 2)
     $                 coords(i,j,k) = 2
               endif
            end do
         end do
      end do
      num_air = 0
      do i = minval(x),maxval(x)
         do j = minval(y),maxval(y)
            do k = minval(z),maxval(z)
               if (coords(i,j,k) == 0) then
                  num_air = num_air + 1
                  if (coords(i-1,j,k) == 1)
     $                 num_open = num_open - 1
                  if (coords(i+1,j,k) == 1)
     $                 num_open = num_open - 1
                  if (coords(i,j-1,k) == 1)
     $                 num_open = num_open - 1
                  if (coords(i,j+1,k) == 1)
     $                 num_open = num_open - 1
                  if (coords(i,j,k-1) == 1)
     $                 num_open = num_open - 1
                  if (coords(i,j,k+1) == 1)
     $                 num_open = num_open - 1
               endif
            end do
         end do
      end do
      print *, "Part 2: ", num_open
      end program
