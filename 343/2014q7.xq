let $d := doc("2014q7.xml")
return ($d/foo/bar[@b="bye"], $d//qux[2])
