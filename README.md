# R과 shiny를 이용한 web application 제작

### 일시: 2017년 10월 13일

### 강의: 문건웅(cardiomoon@gmail.com) 

### 내용: 

---

# 자료 다운로드

https://github.com/cardiomoon/shinyLecture2
 

---


### 강의 진행에 필요한 사항

강의는 실습과 같이 진행됩니다. 강의를 들으시는 분들은 자신의 컴퓨터에 R과 RStudio가 설치되어 있어야 하며 RStudio에서 실습에 필요한 다음 패키지들을 설치하시기 바랍니다.

- R 설치 :  
    - https://www.r-project.org/
    - http://cran.nexr.com/
    

- RStudio 설치: 
    - https://www.rstudio.com/products/rstudio/download/#download

필요한 R 패키지 : R console에서 다음 명령어 실행

```
install.packages("knitr","shiny","rmarkdown")
install.packages("tidyverse","DT","moonBook")
```

6번째 앱에서 knitr Reports 중 pdf 다운로드를 위하여는 LaTex 설치가 필요하다. (http://ktug.or.kr)

9번째 interactive plot 을 위해서는 다음 패키지들의 설치가 필요하다.
```
install.packages("ggiraph","ggiraphExtra")
```

### 강의록

강의에는 다음 파일이 사용됩니다.

- shiny1.pdf

- shiny2.pdf

- Shiny3.pdf

---

### 예제 파일들

다음 예제 파일들이 사용됩니다.

- app.R

- ggbrush.R

- pick_points.R

- inst/ 폴더에 있는 모든 예제 파일들