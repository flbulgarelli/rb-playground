Compare results:

((1..10000).map do run(:keep) end).select {|it| it}.size

vs

((1..10000).map do run(:swap) end).select {|it| it}.size
