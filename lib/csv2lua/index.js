const csv = require('csvtojson');
const fs = require('fs');

const versions = ['CTP', 'J', 'U'];

const csvToLua = async version => {
    const inputPath = `csv/${version}.csv`;
    const outputPath = `../tech_data_${version}.lua`;
    // const outputPath = `output/tech_data_${version}.lua`;

    // string to write to lua file
    let output = 'tech_data = {';

    // convert csv to json
    const json = await csv({
        ignoreColumns: /^$/
    }).fromFile(inputPath);

    // iterate through each row, process, and add to output
    json.forEach((row, index) => {
        if (index) {
            output += ',';
        }
        output =
`${output}
    {
        id = 0x${row.ID},
        name = "${row.Name}",
        pc1 = "${row['PC 1']}",
        pc2 = "${row['PC 2']}",
        pc3 = "${row['PC 3']}",
        target = "${row.Target}",
        type1 = "${row['Type 1']}",
        type2 = "${row['Type 2']}",
        type3 = "${row['Type 3']}",
        status = "${row.Status}"
    }`;
    });

    // finalize output
    output += '\n}\n';

    // print file
    fs.writeFile(outputPath, output, err => {
        if (err) {
            return console.log(err);
        }
        console.log(`success ${outputPath}`);
    });
};

// convert csv to lua for each version
versions.forEach(csvToLua);
