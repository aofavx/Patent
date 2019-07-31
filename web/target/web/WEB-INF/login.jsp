<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<title>-专利分类系统登录-</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/static/bulma/bulma.min.css" >
<style>
canvas {
    display: block;
    width: 100%;
    height: 100%;
    position:absolute;z-index:-2;
  }
</style>
</head>
<body style="" >
<canvas id="canvas"></canvas>

<div class="columns  is-centered">

  <div id="parent" class=" box column is-one-fifth" >
      <c:if test="${not empty msg}">
     <div class="notification 
     <c:if test="${status=='1'}" >
     is-info
     </c:if>
     <c:if test="${status=='0'}" >
     is-warning
     </c:if>
     <c:if test="${status=='-1'}" >
     is-danger
     </c:if> 
     <c:if test="${status=='2'}" >
     is-success
     </c:if> ">
      <button class="delete"></button>
     <small>${msg }</small> 
     </div>
    </c:if>
  <form id="form" action="" method="post" >
    <div class="field">
      <label class="label">Name</label>
      <div class="control">
        <input id="name" class="input" name="name" type="text" placeholder="账号名">
      </div>
      <p id="name-help"  class="help"></p>
    </div>
    <div class="field">
      <label class="label">Password</label>
      <div class="control">
        <input id="password" class="input" name="password" type="text" placeholder="密码">
      </div>
      <p id="password-help"  class="help"></p>
    </div>
    
    <a  id="login-a" class="button is-primary" onclick="login()">登录</a>
    <a id="register-a" onclick="register()" class="button is-link is-inverted is-pulled-right">注册</a>
    </form>
  </div>
</div>

<script src="<%=request.getContextPath()%>/static/jq.min.js"></script>
<script type="text/javascript">
$(function(){
	$('#parent').css({ 
		position:'absolute', 
		left: ($(window).width() - $('#parent').outerWidth())/2, 
		top: ($(window).height() - $('#parent').outerHeight())/2 + $(document).scrollTop() 
		}); 

	$(".delete").click(function(){
		$(this).parent(".notification").fadeOut();
		
	});
	setTimeout(function(){
		$(".notification").fadeOut();
	},5000);
});
function test(){
	$('#name').attr('class','input');
	$('#password').attr('class','input');
	$('#name-help').text('');
	$('#password-help').text('');
	var name=$('#name').val();
	var password=$('#password').val();
	if(name.trim()==""){
		$('#name-help').text('账号不能为空');
		//$('#name-help').show();
		$('#name').attr('class',$('#name').attr('class')+" is-warning");
		return false;
	}
	if(password.trim()==""||password.length<3){
		$('#password-help').text('密码不能为空或长度不足');
		$('#password').attr('class',$('#name').attr('class')+" is-warning");
		return false;
	}
	var reg=/[0-9A-Za-z#?!^&*-=.]{3,}$/;
	if(!reg.test(password)){
		$('#password-help').text('密码含有非法字符！');
		$('#password').attr('class',$('#name').attr('class')+" is-warning");
		return false;
	}
	return true;
}
function login(){
	if(test()){
		$("#login-a").attr("class",$("#login-a").attr("class")+" is-loading");
		$('#form').attr("action","<%=request.getContextPath()%>/login").submit();
	}
}
function register(){
	if(test()){
	$("#register-a").attr("class",$("#register-a").attr("class")+" is-loading");
	$('#form').attr("action","<%=request.getContextPath()%>/register").submit();
	}
}

</script>
<script type="text/javascript">
class Circle {
  //创建对象
  //以一个圆为对象
  //设置随机的 x，y坐标，r半径，_mx，_my移动的距离
  //this.r是创建圆的半径，参数越大半径越大
  //this._mx,this._my是移动的距离，参数越大移动
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.r = Math.random() * 10;
    this._mx = Math.random();
    this._my = Math.random();
  }
  //canvas 画圆和画直线
  //画圆就是正常的用canvas画一个圆
  //画直线是两个圆连线，为了避免直线过多，给圆圈距离设置了一个值，距离很远的圆圈，就不做连线处理
  drawCircle(ctx) {
    ctx.beginPath();
    //arc() 方法使用一个中心点和半径，为一个画布的当前子路径添加一条弧。
    ctx.arc(this.x, this.y, this.r, 0, 360)
    ctx.closePath();
    ctx.fillStyle = 'rgba(204, 204, 204, 0.3)';
    ctx.fill();
  }
  drawLine(ctx, _circle) {
    let dx = this.x - _circle.x;
    let dy = this.y - _circle.y;
    let d = Math.sqrt(dx * dx + dy * dy)
    if (d < 150) {
      ctx.beginPath();
      //开始一条路径，移动到位置 this.x,this.y。创建到达位置 _circle.x,_circle.y 的一条线：
      ctx.moveTo(this.x, this.y); //起始点
      ctx.lineTo(_circle.x, _circle.y); //终点
      ctx.closePath();
      ctx.strokeStyle = 'rgba(204, 204, 204, 0.3)';
      ctx.stroke();
    }
  }
  // 圆圈移动
  // 圆圈移动的距离必须在屏幕范围内
  move(w, h) {
    this._mx = (this.x < w && this.x > 0) ? this._mx : (-this._mx);
    this._my = (this.y < h && this.y > 0) ? this._my : (-this._my);
    this.x += this._mx / 2;
    this.y += this._my / 2;
  }
}
//鼠标点画圆闪烁变动
class currentCirle extends Circle {
  constructor(x, y) {
    super(x, y)
  }
  drawCircle(ctx) {
    ctx.beginPath();
    //注释内容为鼠标焦点的地方圆圈半径变化
    //this.r = (this.r < 14 && this.r > 1) ? this.r + (Math.random() * 2 - 1) : 2;
    this.r = 8;
    ctx.arc(this.x, this.y, this.r, 0, 360);
    ctx.closePath();
    //ctx.fillStyle = 'rgba(0,0,0,' + (parseInt(Math.random() * 100) / 100) + ')'
    ctx.fillStyle = 'rgba(255, 77, 54, 0.6)'
    ctx.fill();
  }
}
//更新页面用requestAnimationFrame替代setTimeout
window.requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame;
let canvas = document.getElementById('canvas');
let ctx = canvas.getContext('2d');
let w = canvas.width = canvas.offsetWidth;
let h = canvas.height = canvas.offsetHeight;
let circles = [];
let current_circle = new currentCirle(0, 0)
let draw = function() {
  ctx.clearRect(0, 0, w, h);
  for (let i = 0; i < circles.length; i++) {
    circles[i].move(w, h);
    circles[i].drawCircle(ctx);
    for (j = i + 1; j < circles.length; j++) {
      circles[i].drawLine(ctx, circles[j])
    }
  }
  if (current_circle.x) {
    current_circle.drawCircle(ctx);
    for (var k = 1; k < circles.length; k++) {
      current_circle.drawLine(ctx, circles[k])
    }
  }
  requestAnimationFrame(draw)
}
let init = function(num) {
  for (var i = 0; i < num; i++) {
    circles.push(new Circle(Math.random() * w, Math.random() * h));
  }
  draw();
}
window.addEventListener('load', init(60));
window.onmousemove = function(e) {
  e = e || window.event;
  current_circle.x = e.clientX;
  current_circle.y = e.clientY;
}
window.onmouseout = function() {
  current_circle.x = null;
  current_circle.y = null;
}
</script>
</body>
</html>