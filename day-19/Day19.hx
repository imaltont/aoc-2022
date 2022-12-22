class Day19 {
  static public function main():Void {
    var oreClayBot = new EReg("(\\d+) ore", "i");
    var obsidianBot = new EReg("(\\d+) ore and (\\d+) clay", "i");
    var geodeBot = new EReg("(\\d+) ore and (\\d+) obsidian", "i");
    var blueprints = new Array();
    var content:String = sys.io.File.getContent("./resources/input");
    for (line in content.split("\n")) {
      var robotPrices = new Array();
      var spec = line.split(".");
      oreClayBot.match(spec[0]);
      robotPrices.push([Std.parseInt(oreClayBot.matched(1)),0,0]);
      oreClayBot.match(spec[1]);
      robotPrices.push([Std.parseInt(oreClayBot.matched(1)),0,0]);
      obsidianBot.match(spec[2]);
      robotPrices.push([Std.parseInt(obsidianBot.matched(1)), Std.parseInt(obsidianBot.matched(2)), 0]);
      geodeBot.match(spec[3]);
      robotPrices.push([Std.parseInt(geodeBot.matched(1)), 0, Std.parseInt(geodeBot.matched(2))]);
      blueprints.push(robotPrices);
    }
    var part1 = 0;
    for (i in 0...blueprints.length) {
      part1 += dfs(blueprints[i], [0,0,0], [0,0,0,0], [1,0,0,0], 24, 0, 0, 0) * (i + 1);
    }
    Sys.print("Part 1: ");
    Sys.println(part1);
    var part2 = 1;
    for (i in 0...Math.ceil(Math.min(blueprints.length, 3))) {
      part2 *= dfs(blueprints[i], [0,0,0], [0,0,0,0], [1,0,0,0], 32, 0, 0, 0);
    }
    Sys.print("Part 2: ");
    Sys.println(part2);
  }
  
  static function dfs(prices, resources, prevRobots, robots, turns, steps, score, maxScore):Int {
    for (i in Math.ceil(Math.max(0,turns-steps))...turns) {
      score += prevRobots[3];
      resources = collectResources(resources, prevRobots);
    }
    turns = turns-steps;
    if (turns <= 0) {
      return score;
    }
    var bestPossible = score;
    for (i in 0...turns) {
      bestPossible += (robots[3] + i);
    }
    if (bestPossible <= maxScore) { 
      return score;
    }
    var neighbors = generateNeighbors(prices, resources, robots);
    var neighborResources = generateResources(prices, resources, robots);
    var neighborSteps = generateSteps(prices, resources, robots);
    for (i in 0...neighbors.length) {
      var newVal = dfs(prices
		       , neighborResources[i]
		       , robots
		       , neighbors[i]
		       , turns
		       , neighborSteps[i]
		       , score
		       , maxScore);
      if (newVal > maxScore) {
	maxScore = newVal;
      }
    }
    return maxScore;
  }
  static function generateNeighbors(prices, resources, robots): Array<Array<Int>> {
    var newNeighbors = new Array();
    if (robots[2] > 0) {
      newNeighbors.push([robots[0], robots[1], robots[2], robots[3]+1]);
    }
    if (robots[1] > 0 && robots[2] < prices[3][2]) {
      newNeighbors.push([robots[0], robots[1], robots[2]+1, robots[3]]);
    }
    if (robots[0] > 0 && robots[1] < prices[2][1]) {
      newNeighbors.push([robots[0], robots[1]+1, robots[2], robots[3]]);
    }
    if (robots[0] > 0 && robots[0] < prices[1][0]) {
      newNeighbors.push([robots[0]+1, robots[1], robots[2], robots[3]]);
    }
    return newNeighbors;
  }
  static function generateResources(prices, resources, robots): Array<Array<Int>> {
    var newResources = new Array();
    if (robots[2] > 0) {
      newResources.push([resources[0]-prices[3][0], resources[1], resources[2] - prices[3][2]]);
    }
    if (robots[1] > 0 && robots[2] < prices[3][2]) {
      newResources.push([resources[0]-prices[2][0], resources[1] - prices[2][1], resources[2]]);
    }
    if (robots[0] > 0 && robots[1] < prices[2][1]) {
      newResources.push([resources[0]-prices[1][0], resources[1], resources[2]]);
    }
    if (robots[0] > 0 && robots[0] < prices[1][0]) {
      newResources.push([resources[0]-prices[0][0], resources[1], resources[2]]);
    }
    return newResources;
  }
  static function generateSteps(prices, resources, robots): Array<Int> {
    var newSteps = new Array();
    if (robots[2] > 0) {
      var obsidianRounds = Math.ceil((prices[3][2] - resources[2]) / robots[2]);
      var oreRounds = Math.ceil((prices[3][0] - resources[0]) / robots[0]);
      newSteps.push(Math.ceil(Math.max(1, 1 + Math.max(obsidianRounds, oreRounds))));
    }
    if (robots[1] > 0 && robots[2] < prices[3][2]) {
      var clayRounds = Math.ceil((prices[2][1] - resources[1]) / robots[1]);
      var oreRounds = Math.ceil((prices[2][0] - resources[0]) / robots[0]);
      newSteps.push(Math.ceil(Math.max(1, 1 + Math.max(clayRounds, oreRounds))));
    }
    if (robots[0] > 0 && robots[1] < prices[2][1]) {
      var oreRounds = Math.ceil(Math.max(1, 1+(prices[1][0] - resources[0]) / robots[0]));
      newSteps.push(oreRounds);
    }
    if (robots[0] > 0 && robots[0] < prices[1][0]) {
      var oreRounds = Math.ceil(Math.max(1, 1+(prices[0][0] - resources[0]) / robots[0]));
      newSteps.push(oreRounds);
    }
    return newSteps;
  }

  static function collectResources(resources, robots):Array<Int> {
    return [resources[0] + robots[0], resources[1] + robots[1], resources[2] + robots[2]];
  }
}