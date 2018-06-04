$(document).on('turbolinks:load', function() {
  $(".tie-input").change(function(e) {
    name = e.target.name;
    score = e.target.value;
    regex = /bets\[(.*)]\[(.*)]/gm;
    result = regex.exec(name);
    match_id = result[1];
    team = result[2];
    opponent = team == "home_score" ? "away_score" : "home_score";
    jquery_exp = "input[name='bets[" + match_id + "][" + opponent  + "]']";
    opponent_score = $(jquery_exp).prop("value");
    div_el = $("div[name='bets[" + match_id + "][advances]']"); 
    if (score == opponent_score) {
      div_el.collapse('show');
    } else {
      div_el.collapse('hide');
    }
  });
});

