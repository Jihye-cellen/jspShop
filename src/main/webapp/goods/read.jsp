<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
	.bi-heart, .bi-heart-fill{
		color:red;
	}
</style>
<div>
	<div class="row my-5">
		<div class="col">
			<img src="${goods.image}" width="90%">
		</div>
		<div class="col">
			<h3>${goods.title}</h3>
			<span class="bi bi-heart-fill" id="heart" gid="${goods.gid}" style="cursor:pointer"></span>
			<span id="fcnt" style="font-size:15px"></span>
			<hr>
			<div class="mb-3">가격: <fmt:formatNumber value="${goods.price}" pattern="#,###원"/></div>
			<div class="mb-3">브랜드: ${goods.brand}</div>
			<div class="mb-3">등록일: ${goods.regDate}</div>
			<div class="mb-3">배송정보: 한진택배</div>
			<div class="mb-3">카드할인: 하나카드 무이자 최대 2개월</div>
			<div class="my-5 text-center">
				<button class="px-5 btn btn-warning" id="buy">바로구매</button>
				<button class="px-5 btn btn-success" id="cart">장바구니</button>
			</div>
		</div>
	</div>
</div>
<jsp:include page="modal_buying.jsp"/>
<div id="div_bottom_image" class="row"></div>

<nav>
  <div class="nav nav-tabs" id="nav-tab" role="tablist">
    <button class="nav-link active" id="nav-home-tab" data-bs-toggle="tab" data-bs-target="#nav-home" type="button" role="tab" aria-controls="nav-home" aria-selected="true">상품리뷰</button>
    <button class="nav-link" id="nav-profile-tab" data-bs-toggle="tab" data-bs-target="#nav-profile" type="button" role="tab" aria-controls="nav-profile" aria-selected="false">상품설명</button>
    
  </div>
</nav>
<div class="tab-content" id="nav-tabContent">
  <div class="tab-pane fade show active" id="nav-home" role="tabpanel" aria-labelledby="nav-home-tab" tabindex="0"><jsp:include page="review.jsp"/></div>
  <div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab" tabindex="0">상품설명</div>
</div>




<script id="temp_image" type="x-handlebars-template">
	{{#each .}}
		<div class="col-2 col-md-4 col-lg-2">
			<div class="mb-2"><img src="{{image}}" width="80%" style="cursor:pointer"></div>
		</div>
	{{/each}}
</script>

<script>

	const gid="${goods.gid}";
	const ucnt="${goods.ucnt}";
	const fcnt="${goods.fcnt}";
	$("#fcnt").html(fcnt);
	
	if(ucnt=="0"){
		$("#heart").removeClass("bi-heart-fill");
		$("#heart").addClass("bi-heart");
	}else{
		$("#heart").removeClass("bi-heart");
		$("#heart").addClass("bi-heart-fill");
	}
	
	//빈하트 클릭한 경우
	$(".bi-heart").on("click", function(){
		const gid=$(this).attr("gid");
		if(uid){
			$.ajax({
				type:"post",
				url:"/favorite/insert",
				data:{uid, gid},
				success:function(){
					alert("좋아요! 등록")
					location.reload(true); //refresh
				}
			});
		}else{
			const target = window.location.href; //돌아올 주소
			sessionStorage.setItem("target", target);
			location.href="/user/login";
		}
	});
	
	
	//채워진 하트를 클릭한 경우
	$(".bi-heart-fill").on("click", function(){
		const gid=$(this).attr("gid");
		$.ajax({
			type:"post",
			url:"/favorite/delete",
			data:{uid, gid},
			success:function(){
				alert("좋아요! 취소");
				location.href="/goods/read?gid=" + gid;
			}
		});
	});
	
	
	let size1=6;
	let page1=1;
	let word="";
	
	getiData();
	function getiData(){
		$.ajax({
			type:"get",
			url:"/goods/list.json",
			data:{word:word, page:page1, size:size1, uid},
			dataType:"json",
			success:function(data){
				const temp = Handlebars.compile($("#temp_image").html());
				$("#div_bottom_image").html(temp(data));
				
			}
		});
	}
	
	$("#buy").on("click", function(){
		if(uid){
		$("#modalBuying").modal("show");
		}
		else{
			alert("로그인이 필요한 작업입니다!")
		}
	})
	
	$("#cart").on("click", function(){
		if(uid){
			//장바구니 넣기
			$.ajax({
				type:"post",
				url:"/cart/insert",
				data:{uid, gid},
				success:function(data){
					let message="";
					if(data=="true"){
						message="장바구니에 넣었습니다.";	
					}else{
						message="장바구니에 있는 상품입니다.";
					}
						if(confirm(message +"\n장바구니로 이동하시겠습니까?")){
							location.href="/goods/cart";
						}else{
							location.href="/";
						}
						
				}
			});
		}else{
			alert("로그인이 필요한 작업입니다.");
			sessionStorage.setItem("target", "/goods/read?gid=" + gid); //로그인을 안한 상태에서의 주소를 저장하고, 로그인을 한 후, getItem을 이용해 다시 그 주소를 꺼낸다.
			location.href="/user/login";
		}
	});

</script>