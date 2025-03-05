<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="org.dspace.preenchimento.util.CalculadoraPreenchimento" %>

<link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/porcentagem-item.css">

	<%
	    Boolean isItem = true;
		Boolean isItemDaColecaoRevista = collections.get(0).getHandle().equals(REVISTAS);
		String pontuacaoMaximaDoItem = CalculadoraPreenchimento.getPontuacaoMaximaDoItem(item);
		String pontuacaoDoItem = CalculadoraPreenchimento.calcularPontuacaoTotalDoItem(item);
		String pontuacaoPorcentagem = CalculadoraPreenchimento.getPorcentagemPontuacaoFromMetadado(item);
	%>

	<div class="row-after-navbar page-content-fallback">
		<br>

		<%
			if (pontuacaoPorcentagem != null)
			{
		%>
			<div class="panel panel-primary">
				<div class="panel-heading font-weight-bold">
					<fmt:message key="jsp.statistics.heading.completion-percentage" />
				</div>

				<div class="panel-body">
					<div class="item-completion-stats">
						<div class="item-completion-bar-container">
							<div class="item-completion-bar"></div>
						</div>

						<div class="item-completion-description-container">
							<p class="item-completion-description-details">
								Total de metadados preenchidos: <%= pontuacaoDoItem %>/<%= pontuacaoMaximaDoItem %>
							</p>
							<%
								if (isItemDaColecaoRevista)
								{
							%>
									<p class="item-completion-description-more">
										Veja: <a href="<%= request.getContextPath()%>/static/pages/MRC-BR-VERSAO-2.pdf">Padrão de metadados para descrição de revistas científicas no Miguilim</a>
									<p>
							<%
								}
								else
								{
							%>
									<p class="item-completion-description-more">
										Veja: <a href="<%= request.getContextPath()%>/static/pages/MPR-BR-VERSAO-1.pdf">Padrão de metadados para descrição de portais de revistas no Miguilim</a>
									</p>
							<%
								}
							%>
						</div>
					</div>
				</div>
			</div>
		<%
			}
		%>

		<br/>

	
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
	    	if (isItem) 
	    	{
		%>
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
	                            <c:forEach items="${statsFileDownloads.matrix}" var="row" varStatus="counter">
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
	                                    <td><c:out value="${statsFileDownloads.colLabels[rowcounter.index]}" />
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
	
		<c:if test="${not empty statsCountryVisits and not empty statsCountryVisits.colLabels}">
			<br/>
			<div class="panel panel-primary">
				<div class="panel-heading font-weight-bold">
	            	<fmt:message key="jsp.statistics.heading.countryvisits" />
				</div>
	            <div>
					<canvas id="canvas-country" height="100" ></canvas>
				</div>
			</div>
		</c:if>
	
		<c:if test="${not empty statsCityVisits and not empty statsCityVisits.colLabels}">
			<br/>
			<div class="panel panel-primary">
				<div class="panel-heading font-weight-bold">
					<fmt:message key="jsp.statistics.heading.cityvisits" />
				</div>
				<div class="panel-body">
					<div>
						<canvas id="canvas-city" height="100" ></canvas>
					</div>
				</div>
			</div>
		</c:if>
		<br/><br/>
	
	</div>

    

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>


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
	                        strokeColor : "rgba(0,127,255, 0.9)",
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
			if (isItem) 
			{
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
			                } <c:if test="${not rowcounter.last}">,</c:if>
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
	   	const cores = ["#071D41", "#292A89", "#E12229", "#0D7AD6", "#2FE6DE", "#FFD100", "#04132A", "#99CC32", "#70DB93", "#6B238E", "#C0D9D9", "#5F9F9F", "#5C3317", "#8C7853", "#DF0101", "#8E2323", "#D98719", "#FF6EC7", "##FF0000"];
        
        <c:if test="${not empty statsCountryVisits and not empty statsCountryVisits.colLabels}">
	        var countryVisitsData = {
	            labels : [<c:forEach items="${statsCountryVisits.matrix}" var="row" varStatus="counter"> <c:forEach items="${row}" var="cell" varStatus="rowcounter">"<c:out value="${statsCountryVisits.colLabels[rowcounter.index]}" />"<c:if test="${not rowcounter.last}">,</c:if></c:forEach></c:forEach>],
	                datasets: [{
	                    data: [<c:forEach items="${statsCountryVisits.matrix}" var="row" varStatus="counter"> <c:forEach items="${row}" var="cell" varStatus="rowcounterValue"><c:out value="${cell}" /><c:if test="${not rowcounterValue.last}">,</c:if></c:forEach></c:forEach>],
	                    responsive: true,
	                    borderWidth: 1,
	                    backgroundColor: cores,
	                    hoverBackgroundColor: cores
	                }]
	        };
        </c:if>


        /****************************************************************************
         * City visits
         ****************************************************************************/
		<c:if test="${not empty statsCityVisits and not empty statsCityVisits.colLabels}">
        	var cityVisitsData = {
                labels : [<c:forEach items="${statsCityVisits.matrix}" var="row" varStatus="counter"> <c:forEach items="${row}" var="cell" varStatus="rowcounter">"<c:out value="${statsCityVisits.colLabels[rowcounter.index]}" />"<c:if test="${not rowcounter.last}">,</c:if></c:forEach></c:forEach>],
                datasets : [{
                	data : [<c:forEach items="${statsCityVisits.matrix}" var="row" varStatus="counter"> <c:forEach items="${row}" var="cell" varStatus="rowcounterValue"><c:out value="${cell}" /><c:if test="${not rowcounterValue.last}">,</c:if></c:forEach></c:forEach>],
                	responsive: true,
                    borderWidth: 1,
                    backgroundColor: cores,
                    hoverBackgroundColor: cores
				}]
            };
        </c:if>
        
    </script>

    <script>

		jQuery.noConflict();
        jQuery(document).ready(function(){

            /** Month stats **/
            <c:if test="${not empty statsMonthlyVisits and not empty statsMonthlyVisits.colLabels}">
	            var ctx = document.getElementById("canvas-month").getContext("2d");
	            new Chart(ctx, {
	                type: 'line',
	                data: lineChartData,
	                options: {
	                    plugins: {
	                        legend: {
	                            display: false
	                        }
	                    }
	                }
				});
			</c:if>

            <%
            if (isItem) 
            {
            %>
	            /** Download stats **/
				<c:if test="${not empty statsFileDownloads and not empty statsFileDownloads.colLabels}">
	            	var ctxchart = document.getElementById("chart-downloads").getContext("2d");
	            	new Chart(ctxchart, {
		                type: 'doughnut',
		                data: downloadsData,
		                options: {
		                    plugins: {
		                        legend: {
		                            display: false
		                        }
		                    }
		                }
					});
	            </c:if>
            <%
         	}
         	%>

	        /** Country Stats **/
	        <c:if test="${not empty statsCountryVisits and not empty statsCountryVisits.colLabels}">        
	            var ctx = document.getElementById("canvas-country").getContext("2d");
	            new Chart(ctx, {
	                type: 'bar',
	                data: countryVisitsData,
	                options: {
	                    plugins: {
	                        legend: {
	                            display: false
	                        }
	                    }
	                }
				});
	        </c:if>
	
			/** City stats **/
			<c:if test="${not empty statsCityVisits and not empty statsCityVisits.colLabels}">
	            var ctx = document.getElementById("canvas-city").getContext("2d");
	            new Chart(ctx, {
	                type: 'bar',
	                data: cityVisitsData,
	                options: {
	                    plugins: {
	                        legend: {
	                            display: false
	                        }
	                    }
	                }
				});
			</c:if>

        });



    </script>

	<% 
		if (pontuacaoPorcentagem != null) {
	%>
		<script type="text/javascript" src="<%= request.getContextPath() %>/static/js/progressbar/progressbar.js"></script>

		<script>
			const createElementFromHTML = (htmlString) => {
				var div = document.createElement("div");
				div.innerHTML = htmlString.trim();
				return div.firstChild;
			}

			const createBar = (maxPercentage) => {
				const container = document.querySelector(".item-completion-bar");
				const tooltipTextClassName = "item-completion-tooltip-text";
				const tooltipArrowClassName = "item-completion-tooltip-arrow";
				const colors = ["#F5560C", "#FE8B34", "#FFD221", "#16A8A8"];
				let defaultPercentage = 0;

				const bar = new ProgressBar.Line(container, {
					easing: "linear",
					duration: 2000 * (maxPercentage / 100),
					trailColor: "transparent",
					svgStyle: { width: "100%", height: "100%" },
					step: (state, bar) => {
						const percentage = Math.round(bar.value() * 100);

						if (bar.text) {
							const tooltipText = document.createElement("p");
							tooltipText.classList.add(tooltipTextClassName);
							tooltipText.textContent = percentage + " %";

							const tooltipArrow = createElementFromHTML(`
							<svg width="9" height="6" viewBox="0 0 9 6" fill="none" xmlns="http://www.w3.org/2000/svg">
								<path d="M6.06208 5C5.29228 6.33333 3.36778 6.33333 2.59798 5L-9.85265e-05 0.499999L8.66016 0.5L6.06208 5Z" fill="#04132A"/>
							</svg>
							`);

							tooltipArrow.classList.add(tooltipArrowClassName);
							bar.text.replaceChildren(tooltipText, tooltipArrow);

							bar.text.style.left = percentage + "%";
						}

						const color = colors[Math.round((percentage / 100) * (colors.length - 1))]
						bar.path.setAttribute("stroke", color);
					},
					text: {
						value: defaultPercentage,
						className: "item-completion-tooltip",
						// Reseta os estilos da biblioteca para só aplicar os estilos
						// customizados
						style: {},
					},
					autoStyleContainer: false,
				});

				return bar;
			}

		const maxPercentage = <%= pontuacaoPorcentagem %>;
		const bar = createBar(maxPercentage);
		bar.set(maxPercentage / 100);
		</script>
	<% 
		}
	%>
