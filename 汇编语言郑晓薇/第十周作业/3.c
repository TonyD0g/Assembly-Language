#include<stdio.h>
int main()
{
    int a[] = {6,5,4,2,3,1};
    int i,j,x;
    for (i = 0; i < 6;i++)
    {
        for (j = i; j < 6 ;j++)
        {
            if(a[i]<a[j])
            {
                x = a[j];
                a[j] = a[i];
                a[i] = x;
            }
        }
    }

    for (i = 0; i < 6;i++)
    {
        printf("%d ", a[i]);
    }
        return 0;
}

        
