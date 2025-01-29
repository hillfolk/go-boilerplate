# Go Boilerplate 

이 프로젝트는 Go 어플리케이션을 빠르게 만들기위한 보일러 플레이트 프로젝트 입니다.
현재는 가장 기초적인 내용만 추가 되었으며 향후 지속적으로 발전시켜나갈 예정입니다. 

This project is a boiler plate project to make GO applications quickly.
Currently, only the most basic content has been added and will continue to develop in the future.

# Project Layout 
- cmd : 명령어 모음 
- log : 로그 관련 기능 모음
- pkg : 팩키지 모음
- type : 상수 모음 
- version : 버전 정보 모음

# Setup 
version/version.go 의 ServiceName 명을 지정합니다. 해당 파일은 Splash 에 적용 됩니다. 

`
const (
    ServiceName = "go-boilerplate" 
)
`

Makefile 의 아래 정보를 수정 합니다. 

`BIN_NAME=go-boilerplate
IMAGE_NAME=hillfolk/${BIN_NAME}
VERSION_PACKAGE := github.com/hillfolk/go-boilerplate/version`


Dockerfile의 "go-boilerplate" 등의 명칭과 경로를 수정합니다.

# Goals for Boilerplate
- 표준 프로젝트 구조 만들기
- 로깅 기능 추가
- Docker 파일을 빠르게 생성

# Reference
- https://github.com/thazelart/golang-cli-template
- https://github.com/rantav/go-template
- https://github.com/rantav/go-archetype