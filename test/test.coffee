DepGraph = require('../lib/dep-graph.js')
depGraph = new DepGraph

exports['Direct dependencies are chained in original order'] = (test) ->
  depGraph.add '0', '1'
  depGraph.add '0', '2'
  depGraph.add '0', '3'
  test.deepEqual depGraph.getChain('0'), ['1', '2', '3']
  test.done()

exports['Indirect dependencies are chained before their dependents'] = (test) ->
  depGraph.add '2', 'A'
  depGraph.add '2', 'B'
  test.deepEqual depGraph.getChain('0'), ['1', 'A', 'B', '2', '3']
  test.done()

exports['getChain can safely be called for unknown resources'] = (test) ->
  test.doesNotThrow -> depGraph.getChain('Z')
  test.deepEqual depGraph.getChain('Z'), []
  test.done()

exports['Cyclic dependencies are detected'] = (test) ->
  depGraph.add 'yin', 'yang'
  depGraph.add 'yang', 'yin'
  test.throws -> depGraph.getChain 'yin'
  test.throws -> depGraph.getChain 'yang'
  test.done()

exports['Arc direction is taken into account (issue #1)'] = (test) ->
  depGraph.add "MAIN", "One"
  depGraph.add "MAIN", "Three"
  depGraph.add "One", "Two"
  depGraph.add "Two", "Three"
  test.deepEqual depGraph.getChain("MAIN"), ['Three', 'Two', 'One']
  test.done()

exports['TODO (issue #2)'] = (test) ->
  map = {"1861":["af42","400d","ffe9","be77","7832","3649","8f61","525d","a342"],"3577":["be77","a342","964d"],"5571":["88cb","af42","400d","765d","4e03","a127","e6d9","38fa","ca2e","1861","be77","3649","7832","964d","8f61","d4f6","a342","165a","525d"],"7832":["3649","6381"],"8573":["7832","be77","3649","8f61","525d","a342","964d","af42","0daa","74ef","4e03"],"af42":["3577","7832","be77","8f61","525d","b6b2"],"4e03":["af42","765d","d9e9","a0e4","f2b7","6e21","732b","44ca","e23c","ed21","98df","e2e2","a342","be77","3649","7832","d4f6","525d","b6b2","964d"],"765d":["af42","be77","7832","3649","d4f6","a342","525d"],"a127":["af42","765d","4e03","7832","be77","3649","964d","a342","8f61","525d"],"e6d9":["ae79","e8f4","af42","4e03","7832","be77","3649","8f61","a342","964d","525d"],"38fa":["af42","0daa","2a56","7cf7","e8f4","4e03","c2da","8573","0ca3","ae64","7832","be77","3649","8f61","525d","a342","964d"],"ca2e":["af42","400d","4e03","74ef","7832","be77","3649","8f61","a342","964d","525d"],"88cb":["964d"],"400d":["be77"],"be77":["a342"],"8f61":["a342"],"a342":["3649"],"525d":["be77"],"d9e9":["af42","be77","7832"],"f2b7":["ef74","be77"],"c2da":["af42","765d","d9e9","a0e4","f2b7","6e21","732b","44ca","e23c","ed21","98df","e2e2","366d","4e03","a342","be77","3649","7832","d4f6","525d","b6b2","964d"],"a0e4":["be77","b6b2"],"6e21":["f2b7","be77"],"732b":["be77"],"e8f4":["d9e9","be77","8f61","a342","525d"],"44ca":["525d"],"e23c":["be77"],"74ef":["d9e9","8f61","a342","be77","525d"],"ae79":["be77"],"0daa":["a342","d4f6"],"2a56":["be77"],"7cf7":["be77","4e03"],"0ca3":["7832","be77","3649","8f61","525d","a342","964d","af42","0daa","74ef","4e03"],"ae64":["7832","be77","3649","8f61","525d","a342","964d","af42","0daa","74ef","4e03"]}
  G = new DepGraph
  for own depender, dependees of map
    for dependee in dependees
      G.add depender, dependee
  chain = G.getChain '5571'
  # "765d" depends on "3649"
  test.ok chain.indexOf("765d") > chain.indexOf("3649"), '(765d->3649) dep fails!'
  test.done()

