FROM public.ecr.aws/docker/library/node:24.11.1-alpine as builder
# 스테이지 1 시작. 별칭은 builder
WORKDIR /app
COPY package*.json .
# 라이브러리 설치 목록 파일만 복사
RUN npm install
# package.json 라이브러리 목록 설치
COPY . .
RUN npm run build
# nodejs환경에서만 돌아가단 동적파일들이
# nginx같은 웹서버에서도 동작하는 정적인파일로 변경되어
# ./dist 경로에 저장됨.

######## 여기까지가 stage 1 ########

FROM public.ecr.aws/docker/library/nginx:alpine
# state 2 시작

COPY ./default.conf /etc/nginx/conf.d/default.conf
# nginx 리버스 프록시설정파일을 컨테이너에 복사

COPY --from=builder /app/dist /usr/share/nginx/html
# 1단계에서 빌드된 정적파일(dist 폴더 내용)을 nginx의 웹루트디렉토리에 복사
