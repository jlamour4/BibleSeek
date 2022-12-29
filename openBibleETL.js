// split by tabs
// 0 section is Topic Name
// 1 section is Start Verse ID
// 2 section is End Verse ID
// 3 Section is # of Votes
// const columns = ["Start Verse ID", "End Verse ID", "Number of Votes"];

// Topic	Start Verse ID	End Verse ID	Votes	#Generated 2022-10-31. Verse ID = bbcccvvv (01 = Gen, 66 = Rev). CC-BY License: www.openbible.info/topics
const fs = require('fs');
const http = require('http');
const https = require('https');
const { url } = require('inspector');

const dataURL = 'https://a.openbible.info/data/topic-votes.txt';
const destPATH = './temp.txt';

var content;
var jsonObject = {}

const proto = https;


async function download(url, filePath) {
    return new Promise((resolve, reject) => {
        const file = fs.createWriteStream(filePath);
        let fileInfo = null;

        const request = proto.get(url, response => {
        if (response.statusCode !== 200) {
            fs.unlink(filePath, () => {
            reject(new Error(`Failed to get '${url}' (${response.statusCode})`));
            });
            return;
        }
        console.log("boom");

        fileInfo = {
            mime: response.headers['content-type'],
            size: parseInt(response.headers['content-length'], 10),
        };

        response.pipe(file);
        });

        // The destination stream is ended by the time it's called
        file.on('finish', () => resolve(fileInfo));

        request.on('error', err => {
            console.log("chicken");
        fs.unlink(filePath, () => reject(err));
        });

        file.on('error', err => {
        fs.unlink(filePath, () => reject(err));
        });

        request.end();
    });
}

async function main() {
    await download(url, destPATH);

    fs.readFile(dataURL, 'utf-8', (err, data) => { 
        if (err) {
            console.log(err);
            return;
        } 
    
        content = data
    
        var linesOfFile = content.split('\n');
        linesOfFile.shift(); //  Remove first line containing columns
    
        var topic;
        for (let line of linesOfFile) {
            let splitLine = line.split('\t');
            topic = splitLine[0];
            if (topic.length === 0) continue;
            if (!(topic in jsonObject)) {
                jsonObject[topic] = [];
            }
            jsonObject[topic].push({'startVerseId': splitLine[1], 'endVerseId': splitLine[2], 'votes': splitLine[3]});
        }
    
        console.log(jsonObject);
        console.log("Number of keys .............. " + Object.keys(jsonObject).length);
        console.log("");
    
    })    
        
}

main();