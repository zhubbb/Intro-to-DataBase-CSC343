


<DEALS>
{
let $d := fn:doc("property.xml") 
for $deal in $d/PROPERTIES/PROPERTY//RENT_AMOUNT[.<=800]
return 
<DEAL> { data($deal) } </DEAL> 

}
</DEALS>


