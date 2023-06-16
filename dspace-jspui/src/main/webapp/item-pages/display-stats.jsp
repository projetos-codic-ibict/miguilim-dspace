<%@page contentType="text/html;charset=UTF-8" %>

<%
    Boolean isItem = true;
%>




    <div class="row-after-navbar page-content-fallback">


        <br/>

        <ul class="list-group">

            <li class="list-group-item">

				<span>
				<strong>
					<fmt:message key="jsp.statistics.heading.visits" />
				</strong>
			</span>
            </li>

        </ul>

        <br/>

        <!--

        Visits per month

        -->
        <c:if test="${not empty statsMonthlyVisits and not empty statsMonthlyVisits.colLabels}">
            <br/>
            <div class="panel panel-primary">

                <div class="panel-heading font-weight-bold">
                    <fmt:message key="jsp.statistics.heading.monthlyvisits" />
                </div>

                <div class="panel-body">


                    <div class="chart-div">

                        <div>
                            <canvas id="canvas-month" height="100" ></canvas>
                        </div>

                    </div>

                </div>

            </div>

        </c:if>


        <%
            if (isItem) {
        %>
        <!--

        Downloads

        -->
        <br/>
        <c:if test="${not empty statsFileDownloads and not empty statsFileDownloads.colLabels}">
            <div class="panel panel-primary">

                <div class="panel-heading font-weight-bold">
                    <fmt:message key="jsp.statistics.heading.filedownloads" />
                </div>

                <div class="panel-body">

                    <div class="chart-div col-md-7">

                        <div>
                            <canvas id="chart-downloads" height="100" ></canvas>
                        </div>

                    </div>


                    <div class="col-md-5">
                        <br/><br/>
                        <table class="statsTable">
                            <tr>
                                <th><fmt:message key="jsp.statistics.heading.download.filename" /></th>
                                <th><fmt:message key="jsp.statistics.heading.download.amout" /></th>
                            </tr>
                            <c:forEach items="${statsFileDownloads.matrix}" var="row"
                                       varStatus="counter">
                                <c:forEach items="${row}" var="cell" varStatus="rowcounter">
                                    <c:choose>
                                        <c:when test="${rowcounter.index % 2 == 0}">
                                            <c:set var="rowClass" value="evenRowOddCol" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="rowClass" value="oddRowOddCol" />
                                        </c:otherwise>
                                    </c:choose>
                                    <tr class="${rowClass}">
                                    <td><c:out
                                            value="${statsFileDownloads.colLabels[rowcounter.index]}" />
                                    <td><span class="pull-right"><c:out value="${cell}" /></span></td>
                                </c:forEach>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>

                </div>

            </div>
        </c:if>

        <%
            }
        %>



        <!--

        Country visits

        -->
        <c:if test="${not empty statsCountryVisits and not empty statsCountryVisits.colLabels}">
            <br/>
            <div class="panel panel-primary">

                <div class="panel-heading font-weight-bold">
                    <fmt:message key="jsp.statistics.heading.countryvisits" />
                </div>

                <div class="panel">

                    <canvas id="canvas-country" height="100" ></canvas>

                </div>

            </div>
        </c:if>



        <!--

        City vitits

        -->
        <c:if test="${not empty statsCityVisits and not empty statsCityVisits.colLabels}">
            <br/>
            <div class="panel panel-primary">

                <div class="panel-heading font-weight-bold">
                    <fmt:message key="jsp.statistics.heading.cityvisits" />
                </div>

                <div class="panel-body">

                    <div class="panel">
                        <canvas id="canvas-city" height="100" ></canvas>
                    </div>

                </div>

            </div>

        </c:if>

        <br/><br/>

    </div>

    <input type="hidden" id="collor0" value="#DF0101">
    <input type="hidden" id="collor0-highlight" value="#B40404">

    <input type="hidden" id="collor1" value="#F4FA58">
    <input type="hidden" id="collor1-highlight" value="#F7D358">

    <input type="hidden" id="collor2" value="#2E2EFE">
    <input type="hidden" id="collor2-highlight" value="#2E64FE">

    <input type="hidden" id="collor3" value="#0B615E">
    <input type="hidden" id="collor3-highlight" value="#0B614B">

    <input type="hidden" id="collor4" value="#DF0101">
    <input type="hidden" id="collor4-highlight" value="#DF0101">

    <input type="hidden" id="collor5" value="#2A0A1B">
    <input type="hidden" id="collor5-highlight" value="#2A0A12">

    <input type="hidden" id="collor6" value="#0B3861">
    <input type="hidden" id="collor6-highlight" value="#0B2161">

    <input type="hidden" id="collor7" value="#81F7BE">
    <input type="hidden" id="collor7-highlight" value="#81F7D8">

    <input type="hidden" id="collor8" value="#181407">
    <input type="hidden" id="collor8-highlight" value="#181907">

    <input type="hidden" id="collor9" value="#01A9DB">
    <input type="hidden" id="collor9-highlight" value="#0174DF">

    <input type="hidden" id="collor10" value="#3A01DF">
    <input type="hidden" id="collor10-highlight" value="#7401DF">

    <input type="hidden" id="collor11" value="#DF01D7">
    <input type="hidden" id="collor11-highlight" value="#DF01A5">

    <input type="hidden" id="collor12" value="#DF013A">
    <input type="hidden" id="collor12-highlight" value="#DF0174">

    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/chartjs-1-0-1-beta2/Chart.js"></script>


    <script>
        jQuery.noConflict();


        /****************************************************************************
         * Month stats
         ****************************************************************************/
            <c:if test="${not empty statsMonthlyVisits and not empty statsMonthlyVisits.colLabels}">

        var lineChartData = {
                labels : [<c:forEach items="${statsMonthlyVisits.colLabels}" var="headerlabel" varStatus="counter">"<c:out value="${headerlabel}" />"<c:if test="${not counter.last}">,</c:if></c:forEach>],
                datasets : [
                    {
                        label: "<fmt:message key="jsp.statistics.heading.monthlyvisits" />",
                        fillColor : "rgba(220,220,220,0.2)",
                        strokeColor : "rgba(220,220,220,1)",
                        pointColor : "rgba(220,220,220,1)",
                        pointStrokeColor : "#fff",
                        pointHighlightFill : "#fff",
                        pointHighlightStroke : "rgba(220,220,220,1)",
                        data: [<c:forEach items="${statsMonthlyVisits.matrix}" var="row" varStatus="counter"><c:forEach items="${row}" var="cell" varStatus="counterSubLoop"><c:out value="${cell}" /><c:if test="${not counterSubLoop.last}">,</c:if></c:forEach></c:forEach>]
                    }
                ]

            };
        </c:if>


        /****************************************************************************
         * Download stats
         ****************************************************************************/
            <%
            if (isItem) {
            %>
            <c:if test="${not empty statsFileDownloads and not empty statsFileDownloads.colLabels}">

        var downloadsData = [
                <c:forEach items="${statsFileDownloads.matrix}" var="row" varStatus="counter">
                <c:forEach items="${row}" var="cell" varStatus="rowcounter">
                {
                    value: <c:out value="${cell}" />,
                    color: <c:choose><c:when test="${rowcounter.index <= 12}">jQuery("#collor" + <c:out value="${rowcounter.index}" />).val()</c:when><c:otherwise>"#A4A4A4"</c:otherwise></c:choose>,
                    highlight: <c:choose><c:when test="${rowcounter.index <= 12}">jQuery("#collor" + <c:out value="${rowcounter.index}" /> + "-highlight").val()</c:when><c:otherwise>"#BDBDBD"</c:otherwise></c:choose>,
                    label: "<c:out value="${statsFileDownloads.colLabels[rowcounter.index]}" />"
                }<c:if test="${not rowcounter.last}">,</c:if>
                </c:forEach>
                </c:forEach>
            ];
        </c:if>

        <%
            }
        %>

        /****************************************************************************
         * Country visits
         ****************************************************************************/

            <c:if test="${not empty statsCountryVisits and not empty statsCountryVisits.colLabels}">

        var countryVisitsData = {
                labels : [<c:forEach items="${statsCountryVisits.matrix}" var="row" varStatus="counter"> <c:forEach items="${row}" var="cell" varStatus="rowcounter">"<c:out value="${statsCountryVisits.colLabels[rowcounter.index]}" />"<c:if test="${not rowcounter.last}">,</c:if></c:forEach></c:forEach>],
                datasets : [

                    {
                        fillColor : "rgba(220,220,220,0.5)",
                        strokeColor : "rgba(220,220,220,0.8)",
                        highlightFill: "rgba(220,220,220,0.75)",
                        highlightStroke: "rgba(220,220,220,1)",
                        data : [<c:forEach items="${statsCountryVisits.matrix}" var="row" varStatus="counter"> <c:forEach items="${row}" var="cell" varStatus="rowcounterValue"><c:out value="${cell}" /><c:if test="${not rowcounterValue.last}">,</c:if></c:forEach></c:forEach>]

                    }
                ]

            };
        </c:if>




        /****************************************************************************
         * City visits
         ****************************************************************************/

            <c:if test="${not empty statsCityVisits and not empty statsCityVisits.colLabels}">

        var cityVisitsData = {
                labels : [<c:forEach items="${statsCityVisits.matrix}" var="row" varStatus="counter"> <c:forEach items="${row}" var="cell" varStatus="rowcounter">"<c:out value="${statsCityVisits.colLabels[rowcounter.index]}" />"<c:if test="${not rowcounter.last}">,</c:if></c:forEach></c:forEach>],
                datasets : [

                    {
                        fillColor : "rgba(220,220,220,0.5)",
                        strokeColor : "rgba(220,220,220,0.8)",
                        highlightFill: "rgba(220,220,220,0.75)",
                        highlightStroke: "rgba(220,220,220,1)",
                        data : [<c:forEach items="${statsCityVisits.matrix}" var="row" varStatus="counter"> <c:forEach items="${row}" var="cell" varStatus="rowcounterValue"><c:out value="${cell}" /><c:if test="${not rowcounterValue.last}">,</c:if></c:forEach></c:forEach>]

                    }
                ]

            };
        </c:if>
    </script>

    <script>

        jQuery.noConflict();
        jQuery(document).ready(function(){

            /** Month stats **/
                <c:if test="${not empty statsMonthlyVisits and not empty statsMonthlyVisits.colLabels}">
            var ctx = document.getElementById("canvas-month").getContext("2d");
            new Chart(ctx).Line(lineChartData, {
                responsive: true
            });
            </c:if>

            <%
            if (isItem) {
            %>
            /** Download stats **/
                <c:if test="${not empty statsFileDownloads and not empty statsFileDownloads.colLabels}">
            var ctxchart = document.getElementById("chart-downloads").getContext("2d");
            new Chart(ctxchart).Doughnut(downloadsData, {
                responsive : true

            });
            </c:if>
            <%
         }
         %>

            /** Country stats **/
                <c:if test="${not empty statsCountryVisits and not empty statsCountryVisits.colLabels}">
            var ctx = document.getElementById("canvas-country").getContext("2d");
            new Chart(ctx).Bar(countryVisitsData, {
                responsive: true
            });
            </c:if>

            /** City stats **/
                <c:if test="${not empty statsCityVisits and not empty statsCityVisits.colLabels}">
            var ctx = document.getElementById("canvas-city").getContext("2d");
            new Chart(ctx).Bar(cityVisitsData, {
                responsive: true
            });
            </c:if>

        });

    </script>
    </script>

