// add your JavaScript/D3 to this file


// JavaScript Code


d3.csv('https://raw.githubusercontent.com/igcc2023/Temp/main/df_growth.csv')
    .then(function(rows) {
        function unpack(rows, key) {
            return rows.map(function(row) { return row[key]; });
        }

        // Get unique causes from the dataset
        var causes = [...new Set(rows.map(row => row.Cause))];

        // Function to calculate min and max growth values
        function getMinMaxGrowth(cause) {
            var causeData = rows.filter(row => row.Cause === cause);
            var growthValues = causeData.map(row => parseFloat(row.Growth));
            var minGrowth = Math.min(...growthValues);
            var maxGrowth = Math.max(...growthValues);
            return [minGrowth * 100, maxGrowth * 100]; // Convert to percentage
        }

        // Initial data setup for the first cause
        var initialCause = causes[0];
        var [initialMinGrowth, initialMaxGrowth] = getMinMaxGrowth(initialCause);
        var filteredData = rows.filter(row => row.Cause === initialCause);

        var data = [{
            type: 'choropleth',
            locationmode: 'USA-states',
            locations: unpack(filteredData, 'State'),
            z: unpack(filteredData, 'Growth').map(x => x * 100), // Convert to percentage
            text: unpack(filteredData, 'State').map((state, i) =>
                `${state}<br>Growth: ${filteredData[i].Growth * 100}%<br>Earliest Rate: ${filteredData[i].EarliestRate}<br>Latest Rate: ${filteredData[i].LatestRate}`),
            colorscale: 'Viridis',
            zmin: initialMinGrowth,
            zmax: initialMaxGrowth
        }];

        var layout = {
            title: 'Death Rate (Age-Adj) From 1999 to 2020',
            geo: {
                scope: 'usa',
                countrycolor: 'rgb(255, 255, 255)',
                showland: true,
                landcolor: 'rgb(217, 217, 217)',
                showlakes: true,
                lakecolor: 'rgb(255, 255, 255)',
                subunitcolor: 'rgb(255, 255, 255)',
                lonaxis: {},
                lataxis: {}
            },
            updatemenus: [{
                buttons: causes.map(cause => {
                    var [minGrowth, maxGrowth] = getMinMaxGrowth(cause);
                    return {
                        args: [{
                            'z': [unpack(rows.filter(row => row.Cause === cause), 'Growth').map(x => x * 100)],
                            'locations': [unpack(rows.filter(row => row.Cause === cause), 'State')],
                            'text': unpack(rows.filter(row => row.Cause === cause), 'State').map((state, i) =>
                                `${state}<br>Growth: ${rows.filter(row => row.Cause === cause)[i].Growth * 100}%<br>Earliest Rate: ${rows.filter(row => row.Cause === cause)[i].EarliestRate}<br>Latest Rate: ${rows.filter(row => row.Cause === cause)[i].LatestRate}`),
                            'zmin': minGrowth,
                            'zmax': maxGrowth
                        }],
                        label: cause,
                        method: 'restyle'
                    };
                }),
                direction: 'down',
                showactive: true,
                x: 0.1,
                xanchor: 'left',
                y: 1.1,
                yanchor: 'top'
            }]
        };

        Plotly.newPlot("plot", data, layout, {showLink: false});
    })
    .catch(function(error) {
        console.error("Error loading data:", error);
    });


