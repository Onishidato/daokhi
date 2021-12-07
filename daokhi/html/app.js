$(document).ready(function(){
    var x = document.getElementById("myAudio"); 
    window.addEventListener("message", function(e){
        var event = e.data.event;
        if (event == "noti"){
            var type = e.data.type;
            var msg = e.data.msg
            var $noti = $(`
                <div class="noti animate__animated animate__slideInDown ${type}">
                    <div class="header text-center h3">
                        CHIẾM ĐÓNG
                    </div>
                    <div class="content text-center">
                        ${msg}
                    </div>
                </div>
            `)
            $(".wrap").append($noti)
            if (type == "warning"){
                x.play();
                x.volume = 0.2;
            }
            setTimeout(function(){
                $noti.addClass("animate__slideOutUp")
            }, 28000)
            setTimeout(function(){
                $noti.remove()
            }, 30000)
        }else if(event == "score-board"){
            var data = e.data.data;
            $("ul").empty();
            for (var i in data){
                var $li = $(`
                    <li>${data[i].name}<span class="point">${data[i].point}</span></li>
                `);
                $li.attr('data-before', parseInt(i)+1);
                /* $("ul").append(`
                    <li >${data[i].name}<span class="point">${data[i].point}</span></li>
                `) */
                $("ul").append($li)
            }
            $(".score-board").fadeIn();
        }  
    })
    window.addEventListener("keyup", e=>{
        if (e.key == "Escape"){
            $(".score-board").fadeOut();
            $("ul").empty();
            $.post("https://lr_occ/Close")
        }
    })
})