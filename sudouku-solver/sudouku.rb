def formatInput(unformattedCSV)
  return unformattedCSV.split('').map(&:to_i).each_slice(9).to_a
end

def existInRow(num, row, current_state)
  (0..8).each do |col|
    if current_state[row][col] == num
      return true
    end 
  end
  return false
end

def existInCol(num, col, current_state)
  (0..8).each do |row|
    if current_state[row][col] == num
      return true
    end
  end 
  return false
end

def existInBox(num, row, col, current_state)
  top_left_row = row/3*3
  top_left_col = col/3*3
  (top_left_row..top_left_row+2).each do |curr_row|
    (top_left_col..top_left_col+2).each do |curr_col|
      if current_state[curr_row][curr_col] == num
        return true
      end
    end
  end
  return false
end

def isSafe?(num, row, col, current_state)
  return !existInRow(num, row, current_state) && !existInCol(num, col, current_state) && !existInBox(num, row, col, current_state) 
end

def findUnassignedEntries(current_state)
  (0..8).each do |row|
    (0..8).each do |col|
      if current_state[row][col] == 0
        return [row, col]
      end

    end
  end
  return nil
end

def solve(current_state)
  next_unassigned = findUnassignedEntries(current_state)
  if next_unassigned == nil
    return true 
  end
  current_row = next_unassigned[0]
  current_col = next_unassigned[1]
  (1..9).each do |number|
    if isSafe?(number, current_row, current_col, current_state)
      current_state[current_row][current_col] = number
      if solve(current_state)
        return true
      end
      current_state[current_row][current_col] = 0
    end    
  end
  return false
end

def print_helper(current_state)
  (0..8).each do |row|
    (0..8).each do |col|
      if col%3 == 0 && col != 0
        print "| "
      end
      print current_state[row][col]
      print " "  
    end
    print "\n"
    if row == 2 || row == 5
      (0..10).each {print "- "}
      print "\n"
    end
  end
end

def solveAndCompare(problem_puzzle, solution_puzzle)
  return true if solve(problem_puzzle) && problem_puzzle == solution_puzzle
  return false
end


def main 
  puts 'Please enter the name of the file containing the sudouku problems and solutions:'
  test_file = gets.chomp
  test_cases = File.readlines(test_file)

  total_time = 0
  test_cases.each_index do |index|
    current_puzzle = test_cases[index].split(",")
    start = Time.now
    print (solveAndCompare(formatInput(current_puzzle[0]), formatInput(current_puzzle[1]))) ? "#{index+1}: Solved! " : "No solution! "
    time_taken = Time.now - start
    print "Time taken: #{time_taken}\n"
    total_time += time_taken
  end 
  print "Average time: #{total_time/test_cases.length}\n"
end

main
