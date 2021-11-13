#include<stdio.h>
int main()
{
    int i = 1, sum = 0;
    while(sum<500)
    {
        sum = sum + i;
        i++;
    }
    printf("The n is :%d  , The sum is :%d \n",i,sum);
    //The n is :33  , The sum is :528
}
