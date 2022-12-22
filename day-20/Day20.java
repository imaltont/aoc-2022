import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.*;

public class Day20 {
	public static void main(String... args) throws Exception {
		File file = new File("./resources/input");
		BufferedReader br = new BufferedReader(new FileReader(file));
		String inputStr;
		List<Long> inputs = new ArrayList<Long>();
		while ((inputStr = br.readLine()) != null) {
			inputs.add((long) Integer.parseInt(inputStr));
		}
		br.close();
		part1(inputs);
		part2(inputs);
	}

	public static void part1(List<Long> inputs) {
		long code = mixer(inputs, 1);
		System.out.println("Part 1: " + Long.toString(code));
	}

	public static void part2(List<Long> inputs) {
		for (int i = 0; i < inputs.size(); i++) {
			inputs.set(i, inputs.get(i) * 811589153);
		}
		long code = mixer(inputs, 10);
		System.out.println("Part 2: " + Long.toString(code));
	}

	public static long mixer(List<Long> inputs, int rounds) {
		Code startInd = null;
		List<Code> initialCodes = new ArrayList<Code>();
		for (int i = 0; i < inputs.size(); i++) {
			if (inputs.get(i) == 0) {
				startInd = new Code(i, inputs.get(i));
				initialCodes.add(startInd);
			} else {
				initialCodes.add(new Code(i, inputs.get(i)));
			}
		}
		List<Code> workingList = new ArrayList<Code>(initialCodes);
		for (int i = 0; i < rounds; i++) {
			for (Code c : initialCodes) {
				long base = workingList.size() - 1;
				long currentIndex = workingList.indexOf(c);
				long targetIndex = workingList.indexOf(c) + c.Value;
				long newTarget = targetIndex;
				long direction = -1;
				if (targetIndex >= base) {
					// while (newTarget >= workingList.size()){
					newTarget = (targetIndex) % base;
					// newTarget += 1;
					// }
				} else if (targetIndex < 0) {
					long intermediate = newTarget % base;
					newTarget = (base + intermediate);
				}
				if (newTarget <= currentIndex) {
					targetIndex = currentIndex;
					currentIndex = newTarget;
					direction = 1;
				} else {
					targetIndex = newTarget;
				}
				Collections.rotate(workingList.subList((int) currentIndex, (int) targetIndex + 1), (int) direction);
			}
		}
		long startIndex = workingList.indexOf(startInd);
		long result = workingList.get((int) (startIndex + 1000) % workingList.size()).Value
				+ workingList.get((int) (startIndex + 2000) % workingList.size()).Value
				+ workingList.get((int) (startIndex + 3000) % workingList.size()).Value;
		return result;
	}
}

class Code {
	public long InitialIndex;
	public long Value;

	public Code(long ind, long val) {
		this.InitialIndex = ind;
		this.Value = val;
	}

	public String toString() {
		return Long.toString(this.Value);
	}
}
