using System.Text.RegularExpressions;
Dictionary<string,Valve> valves = ParseInput("./resources/input");

Part1(valves);
foreach (var key in valves.Keys)
{
    valves[key].IsOpen = false;
}
Part2(valves);

void Part1(Dictionary<string, Valve> valves)
{
    double score = 0.0D;
    Valve current = valves["AA"];
    List<double> openFlow = new List<double>();
    Dictionary<int, bool> openValves = new Dictionary<int, bool>();
    List<double> flows = new List<double>();
    List<string> keys = new List<string>();
    var (distances, paths) = (FloydWarshall(valves));
    foreach (var valve in valves)
    {
        flows.Add(valve.Value.Flow);
        keys.Add(valve.Key);
        if (valve.Value.Flow == 0.0)
        {
            openValves.Add(valve.Value.Index, true);
            valve.Value.IsOpen = true;
        }
    }
    List<int> path = DFS(valves, distances, paths);
    List<int> localPath = GetPath(paths, path[0], path[1]);
    for (int n = 1; n < 31; n++)
    {
        foreach (double flow in openFlow)
        {
            score += flow;
        }
        if (path.Count <= 1)
        {
            continue;
        }
        if (localPath.Count != 0)
        {
            current = valves[keys[localPath[0]]];
            localPath.RemoveAt(0);
        }
        else
        {
            if (current.IsOpen)
            {
                continue;
            }
	    else
            {
                openValves.Add(current.Index, true);
                openFlow.Add(current.Flow);
                current.IsOpen = true;
            }
            path.RemoveAt(0);
            if (localPath.Count == 0 && path.Count > 1)
            {
                localPath = GetPath(paths, path[0], path[1]);
            }
        }
    }
    Console.WriteLine($"Part 1: {score}");
}

void Part2(Dictionary<string, Valve> valves)
{
    double score = 0.0D;
    Valve current = valves["AA"];
    List<double> openFlow = new List<double>();
    Dictionary<int, bool> openValves = new Dictionary<int, bool>();
    List<double> flows = new List<double>();
    List<string> keys = new List<string>();
    var (distances, paths) = (FloydWarshall(valves));
    foreach (var valve in valves)
    {
        flows.Add(valve.Value.Flow);
        keys.Add(valve.Key);
        if (valve.Value.Flow == 0.0)
        {
            openValves.Add(valve.Value.Index, true);
            valve.Value.IsOpen = true;
        }
    }
    var (bestPath, path, path2) = DFS2(valves, distances, paths);
    score = bestPath;
    Console.WriteLine($"Part 2: {score}");
}

List<int> GetPath(int[,] paths, int start, int goal) 
{
    var path = new List<int>();
    int current = start;
    while (current != goal)
    {
        current = paths[current, goal];
        path.Add(current);
    }
    return path;
}

List<int> DFS(Dictionary<string, Valve> valves, double[,] distances, int[,] paths, int start = 30)
{
    List<int> path = new List<int> { valves["AA"].Index };
    List<int> dummyPath = new List<int> { valves["AA"].Index };
    Dictionary<string, bool> visited = new Dictionary<string, bool>();
    double val = double.NegativeInfinity;
    double pathVal = 0;
    foreach (var valve in valves)
    {
        if (valve.Value.Flow == 0)
        {
            visited.Add(valve.Value.Name, true);
        }
    }
    foreach (var valve in valves)
    {
        if (!visited.ContainsKey(valve.Key))
        {
	
            pathVal = (start - distances[valves["AA"].Index, valve.Value.Index] - 1) * valve.Value.Flow;
            Dictionary<string, bool> tmpVisit = new Dictionary<string, bool>(visited);
            tmpVisit.Add(valve.Key, true);
            var tmpPath = new List<int>(path);
            tmpPath.Add(valve.Value.Index);
            var (retVal, retPath) = DFS_visit(valves, distances, paths, tmpVisit, tmpPath, valve.Value, start - distances[valves["AA"].Index, valve.Value.Index] - 1);
            if (val < retVal)
            {		
                val = retVal;
                dummyPath = retPath;
            }
        }
    }
    return dummyPath;
}

(double, List<int>, List<int>) DFS2(Dictionary<string, Valve> valves, double[,] distances, int[,] paths)
{
    List<int> path = new List<int> { valves["AA"].Index };
    List<int> dummyPlayer = new List<int> { valves["AA"].Index };
    List<int> dummyElephant = new List<int> { valves["AA"].Index };
    Dictionary<string, bool> visited = new Dictionary<string, bool>();
    double val = double.NegativeInfinity;
    double pathVal = 0;
    foreach (var valve in valves)
    {
        if (valve.Value.Flow == 0)
        {
            visited.Add(valve.Value.Name, true);
        }
    }
    foreach (var valve in valves)
    {
        if (!visited.ContainsKey(valve.Key))
        {
	
            pathVal = (26 - distances[valves["AA"].Index, valve.Value.Index] - 1) * valve.Value.Flow;
            Dictionary<string, bool> tmpVisit = new Dictionary<string, bool>(visited);
            tmpVisit.Add(valve.Key, true);
            var tmpPath = new List<int>(path);
            tmpPath.Add(valve.Value.Index);
            var (retVal, retPPath, retEPath) = DFS_visit2(valves
		, distances
		, paths
		, tmpVisit
		, tmpPath
		, path
		, valve.Value
		, valves["AA"]
		, 26 - distances[valves["AA"].Index, valve.Value.Index] - 1
		, 26
		, true);
            if (val < retVal)
            {		
                val = retVal;
                dummyPlayer = retPPath;
                dummyElephant = retEPath;
            }
        }
    }
    return (val, dummyPlayer, dummyElephant);
}

(double, List<int>, List<int>) DFS_visit2(Dictionary<string, Valve> valves, double[,] distances, int[,] paths, Dictionary<string,bool> visited, List<int> playerPath, List<int> elephantPath, Valve player, Valve elephant, double playerTime, double elephantTime, bool wasPlayer)
{
    double time;
    double time2;
    double addedVal;

    if (wasPlayer)
    {
        time = playerTime;
        time2 = elephantTime;
        addedVal = Math.Max(0, time) * player.Flow;
    }
    else
    {
        time = elephantTime;
        time2 = playerTime;
        addedVal = Math.Max(0, time) * elephant.Flow;
    }
    List<int> dummyPlayer = new List<int>(playerPath);
    List<int> dummyElephant = new List<int>(elephantPath);
    double result = addedVal;
    // return case if time runs out
    if (time <= 0 && time2 <= 0)
    {
        return (0, dummyPlayer, dummyElephant);
    }
    foreach (var valve in valves)
    {
        if (!visited.ContainsKey(valve.Key) && valve.Value.Index != player.Index)
        {
            Dictionary<string, bool> tmpVisit = new Dictionary<string, bool>(visited);
            tmpVisit.Add(valve.Key, true);
            List<int> tmpPath;
            bool tmpIsPlayer;
            Valve current;
            if (elephantTime > playerTime)
            {
                tmpIsPlayer = false;
                tmpPath = new List<int>(elephantPath);
                current = elephant;
            }
            else
            {
                tmpIsPlayer = true;
                tmpPath = new List<int>(playerPath);
                current = player;
	    }
            tmpPath.Add(valve.Value.Index);
            var (retVal, retPPath, retEPath) = DFS_visit2(valves
		, distances
		, paths
		, tmpVisit
		, tmpIsPlayer ? tmpPath : playerPath
		, tmpIsPlayer ? elephantPath : tmpPath
		, tmpIsPlayer ? valve.Value : player
		, tmpIsPlayer ? elephant : valve.Value 
		, tmpIsPlayer ? playerTime - distances[current.Index, valve.Value.Index] - 1 : playerTime
		, tmpIsPlayer ? elephantTime : elephantTime - distances[current.Index, valve.Value.Index] - 1
		, tmpIsPlayer);
            if (result < addedVal + retVal)
            {
                result = addedVal + retVal;
                dummyPlayer = retPPath;
                dummyElephant = retEPath;
            }
        }
    }
    return (result, dummyPlayer, dummyElephant);
}

(double, List<int>) DFS_visit(Dictionary<string, Valve> valves, double[,] distances, int[,] paths, Dictionary<string,bool> visited, List<int> path, Valve current, double time)
{
    double addedVal = Math.Max(0, time) * current.Flow;
    List<int> dummyPath = new List<int>(path);
    double result = addedVal;
    // return case if time runs out
    if (addedVal == 0)
    {
        return (0, path);
    }
    foreach (var valve in valves)
    {
        if (!visited.ContainsKey(valve.Key) && valve.Value.Index != current.Index)
        {
            Dictionary<string, bool> tmpVisit = new Dictionary<string, bool>(visited);
            tmpVisit.Add(valve.Key, true);
            var tmpPath = new List<int>(path);
            tmpPath.Add(valve.Value.Index);
            var (retVal, retPath) = DFS_visit(valves, distances, paths, tmpVisit, tmpPath, valve.Value, time - distances[current.Index, valve.Value.Index] - 1);
            if (result < addedVal + retVal)
            {
                result = addedVal + retVal;
                dummyPath = retPath;
            }
        }
    }
    return (result, dummyPath);
}

(double[,], int[,]) FloydWarshall(Dictionary<string, Valve> valves)
{
    var distance = new double[valves.Keys.Count,valves.Keys.Count];
    var paths = new int[valves.Keys.Count,valves.Keys.Count];
    for (int i = 0; i < distance.GetLength(0); i++)
    {
	for (int j = 0; j < distance.GetLength(0); j++)
	{
            if (i != j)
            {
                distance[i, j] = double.PositiveInfinity;
            }
            paths[i, i] = -1;
	}
    }
    foreach (Valve valve in valves.Values)
    {
        foreach (string tunnel in valve.Tunnels)
        {
            distance[valve.Index, valves[tunnel].Index] = 1;
            paths[valve.Index, valves[tunnel].Index] = valves[tunnel].Index;
        }
    }
    var indiceKeys = new List<string>();
    foreach (string name in valves.OrderBy(k => k.Value.Index).Select(k => k.Value.Name))
    {
        indiceKeys.Add(name);
    }
    for (int k = 0; k < distance.GetLength(0); k++)
    {
        for (int i = 0; i < distance.GetLength(0); i++)
        {
            for (int j = 0; j < distance.GetLength(0); j++)
            {
                if (distance[i, j] > distance[i, k] + distance[k, j])
                {
                    distance[i, j] = distance[i, k] + distance[k, j];
                    paths[i, j] = paths[i, k];
                }
            }
        }
    }
    return (distance, paths);
}

Dictionary<string, Valve> ParseInput(string path)
{
    var valves = new Dictionary<string, Valve>();
    var regexParser = new Regex(@"^Valve (?<name>[A-Z]*) has flow rate=(?<flow>[0-9]+); (tunnel|tunnels) (lead|leads) to (valve|valves) (?<tunnels>.*)$");
    var index = 0;
    foreach (string line in System.IO.File.ReadAllLines(path))
    {
        MatchCollection matches = regexParser.Matches(line);
        string name = matches[0].Groups["name"].Value;
        int flow = int.Parse(matches[0].Groups["flow"].Value);
        string tunnels = matches[0].Groups["tunnels"].Value;
        valves.Add(name, new Valve(name, flow, tunnels, index++));
    }
    return valves;
}

void PrintArray<T>(T[,] arr)
{
    var printStr = "";
    for (int i = 0; i < arr.GetLength(0); i++)
    {
        printStr += "\n";
        for (int j = 0; j < arr.GetLength(0); j++)
        {
	    printStr += arr[i,j].ToString() + ",";
	}
    }
    Console.WriteLine(printStr);
}

public class Valve
{
    public string Name { get; set; }
    public double Flow { get; set; }
    public int Index { get; set; } 
    public bool IsOpen { get; set; }
    public List<string> Tunnels { get; set; }
    public Valve(string name, int flow, string tunnels, int index)
    {
        Name = name;
        Flow = (double)flow;
        IsOpen = false;
	Tunnels = new string(tunnels.Where(c => !Char.IsWhiteSpace(c)).ToArray()).Split(',').ToList();
        Index = index;
    }
    public override string ToString()
    {
        var retStr = $"Valve: {Name}, with flow: {Flow} and tunnels to: ";

        foreach (string tunnel in Tunnels)
        {
            retStr += tunnel.ToString() + ",";
        }
        retStr = retStr.Trim(',');
        retStr += $". It uses index {Index} for pathfinding.";
        return retStr;
    }
}
