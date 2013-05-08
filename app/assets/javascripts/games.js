var play_ground = {

getBallAttr: function($li) {
        var color = parseFloat($li.children().attr('alt'));
        var col = $li.closest("ul").index();
        var row = $li.closest("li").index();
        return  {ball: {color: color, row: row, col: col}};
},

makeBallsSelected: function(balls){
    play_ground.makeBallsUnselected();
    for (var ball in balls){
        var $li = $('#play_ground ul').eq(balls[ball].col).children().eq(balls[ball].row)
        var img_src = $li.children().attr('src').split('.');
        var new_img_src = img_src[0]+"_s." + img_src[1];
        $li.children().attr('src', new_img_src);
        $li.addClass('selected');
    }
},

makeBallsUnselected: function(){
    var balls = $('#play_ground').find('li.selected');
    if (balls.length  > 0){
          for (var ball = 0; ball < balls.length; ball++){
              $li = $(balls[ball]);
              var new_img_src = $li.children().attr('src').split('_s');
              var img_src = new_img_src[0] + new_img_src[1];
              $li.children().attr('src', img_src);
              $li.removeAttr('class');
          }
    }
},

updateBalls: function(selected, added){
      var removed = 0;
      for (var ball in selected){
          var $ul = $('#play_ground ul').eq(selected[ball].col)
          var $li = $('#play_ground ul').eq(selected[ball].col).children().eq(selected[ball].row);
          // $li.fadeOut("slow", complete);

          $li.fadeOut("slow", function(){
              $(this).remove(); removed++;
                  if (removed == selected.length){
                      play_ground.addBalls(added);
                  }
              });
      }
},

addBalls: function(added){
      var curr_url = window.location.pathname;
      $.ajax({
            contentType: "application/json",
            dataType: "script",
            type: "POST",
            url: curr_url + '/add_balls',
            data:  JSON.stringify({added: added})
        });
},

addBallss: function(added){
      for (var ball in added){
          var $ul = $('#play_ground ul').eq(added[ball].col);
          // var $li = $('#play_ground ul').eq(added[ball].col).children().eq(added[ball].row);
          var c = added[ball].color;
          // $ul.prepend('<li><img height="38" width="38" src="/assets/balls/"'+colors[c]+' alt="'+c+'"></li>');
      }
}
};

var game = {

selected:[],

alreadySelected: function(li){
    selected = game.selected;
    for (var ball=0; ball < selected.length; ball++){
          if ((selected[ball].col == li.col)&&(selected[ball].row==li.row)){
            return true;
          }
    }
    return false;
},

updateScore: function(score){
      $('#score').text(score);
},

selectGroup:  function (){
      $('#play_ground').on('mouseenter', 'ul li', function(){
            var li = play_ground.getBallAttr($(this));
            if (game.alreadySelected(li.ball) == false){

                var curr_url = window.location.pathname;
                 $.ajax({
                      contentType: "application/json",
                      dataType: "json",
                      type: "POST",
                      url: curr_url + '/select_group',
                      data:  JSON.stringify(li),
                      success: function(selected){
                          if (selected){
                              game.selected = selected;
                              play_ground.makeBallsSelected(selected);
                          }
                        }
                  });
              }
          });
},

updateGame:  function (){
      $('#play_ground').on('click', 'ul li', function(){
            var li = play_ground.getBallAttr($(this));
            var curr_url = window.location.pathname;
             $.ajax({
                  contentType: "application/json",
                  dataType: "json",
                  type: "POST",
                  url: curr_url + '/update_game',
                  data:  JSON.stringify(li),
                  success: function(data){
                    game.updateScore(data.score);
                    play_ground.updateBalls(data.selected, data.added);
                  }
              });
      });
}

}


game.selectGroup();
game.updateGame();
