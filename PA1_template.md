---
title: "Reproducible Research Peer Assessment 1"
output: html_document
---

### check my working directory

```r
#setwd(mywd)
getwd()
```

```
## [1] "C:/Users/Shenfeng Qiu/Documents/CE_Reproducible_Research"
```
### Loading the data


```r
activity <- read.csv("activity.csv")
```

##What is mean total number of steps taken per day?


```r
totalsteps <- aggregate(steps ~ date, data = activity, FUN = sum)
```




```r
hist(totalsteps$steps,col="blue", xlab="Number of Steps", main="Total number of steps taken each day")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 
 
 

```r
meansteps <- mean(totalsteps$steps)  
mediansteps <- median(totalsteps$steps)
```

The mean total number of steps taken per day is 'r meansteps'
The median total number of steps taken per day is 'r mediansteps'

## What is the average daily activity pattern?

#### calculate the average number of steps taken, averaged across all days and make a time series plot against the 5-minute interval


```r
ave5 <- aggregate(steps ~ interval, data = activity, FUN = mean, na.rm = TRUE)
ave5$inter <- (as.numeric(rownames(ave5))-1)*5
plot(ave5$inter, ave5$steps, type = "l", xlab="interval", ylab= "aveg steps")
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 



```r
maxtime <- ave5[ave5$steps== max(ave5$steps),1]  
```

'r maxtime' 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps


## Imputing missing values


```r
missingvalues <- sum(complete.cases(activity))
```
the total number of missing values in the dataset is 'r missingvalues'

####  Create a new dataset that is equal to the original dataset but with all the missing data replaced by  the mean.


```r
a <-activity
for (i in which(sapply(a, is.numeric))) {
    a[is.na(a[, i]), i] <- mean(a[, i],  na.rm = TRUE)
}
```



```r
newtotalsteps <- aggregate(steps ~ date, data = a, FUN = sum)
hist(newtotalsteps$steps,col="green", xlab="Steps",
     main="Total number of steps taken each day (new dataset)")
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9.png) 

```r
newmeansteps <- mean(newtotalsteps$steps)  
newmediansteps <- median(newtotalsteps$steps) 
```

The mean total number of steps taken per day is 'r newmeansteps', which is the same as the mean from the earlier part of the assignment.
The median total number of steps taken per day is 'r newmediansteps', which is similar to the earlier one. 


## Are there differences in activity patterns between weekdays and weekends?

#### add new factor colum "day" to the dataset. The new variables have two levels:  "weekday" and "weekend"

```r
a1<-a
a1$date <- as.Date(a1$date)
a1$day<- ifelse(weekdays(a1$date) %in% c("Saturday", "Sunday"), c("weekend"), c("weekday"))
a1$day <- as.factor(a1$day)
```


####calculate the average number of steps taken, averaged across all days.


```r
new_ave5 <- aggregate(steps ~ day+interval, data = a1, FUN = mean, na.rm = TRUE)
```

#### transform the dataset, changing interval to time format

```r
a2<-new_ave5
str(a2)
```

```
## 'data.frame':	576 obs. of  3 variables:
##  $ day     : Factor w/ 2 levels "weekday","weekend": 1 2 1 2 1 2 1 2 1 2 ...
##  $ interval: num  0 0 5 5 10 10 15 15 20 20 ...
##  $ steps   : num  7.01 4.67 5.38 4.67 5.14 ...
```

```r
Sys.setlocale(category = "LC_TIME", locale = "US") 
```

```
## [1] "English_United States.1252"
```

```r
for (i in 1:nrow(a2)) {
    t1 <- a2[i,2]
    t2 <- trunc(t1/100)
    t3 <- t1-t2*100
    a2[i,4] <- format(as.POSIXct('0001-01-01 00:00:00') + (t2*3600+t3*60), "%k:%M") 
}

names(a2)[4] <- "inter"
```

#### compare the activity patterns between weekdays and weekends

```r
library(ggplot2)

g <- ggplot(a2, aes(inter,steps)) + geom_line(aes(group=day, color=day))
g + facet_grid(day~.,) +
  labs(title = "Average daily activity pattern") +
  labs(x = "interval") +
  labs(y = "Number of Steps")
```

![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13.png) 

