#!/usr/bin/clojure -M
(require '[clojure.string :as str])
(use '[clojure.java.shell :only [sh]])
(def inputs (slurp "./resources/test"))

(defn parse-inputs [inputs]
  (let [spinput (str/split-lines inputs)]
    (into [] (map (fn [line]
                    (let [inp (str/split (str/replace line " " "") #":")]
                      (into [] (cons (symbol (first inp))
                                     (if (every? #(Character/isDigit %) (first (rest inp)))
                                       (cons (Integer/parseInt (first (rest inp))) nil)
                                       (let* [val (first (rest inp))
                                              operator (str (nth val 4))
                                              monkeys (str/split val #"[+/*-]")]
                                         (cons (symbol operator)
                                               (cons (symbol (first monkeys))
                                                     (cons (symbol (first (rest monkeys))) nil)))))))))
                  spinput))))

(defn make-monkey-map [monkeys]
  (let [keys (map (fn [x]
                    (first x))
                  monkeys)
        values (map (fn [x]
                      (rest x))
                    monkeys)]
    (zipmap keys values)))

(defn get-monkey-val [monkeys monkey]
  (let [m (get monkeys monkey)]
    (if (int? (first m))
      (first m)
      (@(resolve (first m))
       (get-monkey-val monkeys (nth m 1))
       (get-monkey-val monkeys (nth m 2))))))

(defn get-human-val [monkeys]
  (letfn [(find-ends [mon path]
            (let [m (get monkeys mon)]
              (if (= mon 'humn)
                mon
                (if (int? (first m))
                  (first m)
                  (conj path
                        (find-ends (nth m 2) path)
                        (first m)
                        (find-ends (nth m 1) path))))))]
    (let* [target (get-monkey-val monkeys (nth (get monkeys 'root) 2))
           m1 (find-ends (nth (get monkeys 'root) 1) nil)]
      (first (rest (re-find #"humn = ([0-9]+)" (get (sh "maxima" (format "--batch-string='%s = %d; solve (%%);'" m1 target)) :out)))))))

(defn part1 []
  (let [monkeys (make-monkey-map
                 (parse-inputs (slurp "./resources/input")))]
    (print "part 1: ")
    (println (get-monkey-val monkeys 'root))))

(defn part2 []
  (let [monkeys (make-monkey-map
                 (parse-inputs (slurp "./resources/input")))]
    (print "part 2: ")
    (print (get-human-val monkeys))
    (println "")))

(part1)
(part2)
(System/exit 0)
