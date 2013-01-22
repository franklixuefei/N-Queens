;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname nqueens) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; Copyright Xuefei Li 2012-2013
;;
;; *************************************************
;;
;; N-queens problem
;;
;; *************************************************
;;

;; Data definition:
;; A Board is a (listof Posn)
  
;; (a)
;; make-board: Nat[>= 1] -> Board
;; Purpose: produces an n*n board, where n is a natural number >= 1.
;; Examples:
(check-expect (make-board 2)
              (list (make-posn 0 0) (make-posn 0 1)
                    (make-posn 1 0) (make-posn 1 1)))
(check-expect 
 (make-board 3)
 (list (make-posn 0 0) (make-posn 0 1) (make-posn 0 2)
       (make-posn 1 0) (make-posn 1 1) (make-posn 1 2)
       (make-posn 2 0) (make-posn 2 1) (make-posn 2 2)))
;; Definition:
(define (make-board n)
  (build-list
   (sqr n)
   (lambda(i)(make-posn (quotient i n) (remainder i n)))))
;; Tests:
(check-expect (make-board 1) (list (make-posn 0 0)))
(check-expect
 (make-board 4)
 (list (make-posn 0 0)(make-posn 0 1)(make-posn 0 2)(make-posn 0 3)
       (make-posn 1 0)(make-posn 1 1)(make-posn 1 2)(make-posn 1 3)
       (make-posn 2 0)(make-posn 2 1)(make-posn 2 2)(make-posn 2 3)
       (make-posn 3 0)(make-posn 3 1)(make-posn 3 2)(make-posn 3 3)))

;; (b)
;; add-queen: Board Posn -> Board
;; Purpose: produces a board resulting from placing a queen
;;          at the given square of the given board.
;; Examples:
(check-expect (add-queen (make-board 3)(make-posn 0 0))
              (list(make-posn 1 2)(make-posn 2 1)))
;; Definition:
(define (add-queen aboard aposn)
  (filter 
   (lambda(x) (not(or (= (posn-x aposn) (posn-x x))
                      (= (posn-y aposn) (posn-y x))
                      (= (abs(- (posn-x aposn)
                                (posn-x x)))
                         (abs(- (posn-y aposn)
                                (posn-y x)))))))
   aboard))
;; Tests:
(check-expect (add-queen (make-board 1)(make-posn 0 0)) empty)
(check-expect
 (add-queen (make-board 2)(make-posn 0 0)) empty)
(check-expect
 (add-queen (make-board 2)(make-posn 1 0)) empty)
(check-expect
 (add-queen (make-board 5)(make-posn 1 2))
 (list(make-posn 0 0)(make-posn 0 4)
      (make-posn 2 0)(make-posn 2 4)
      (make-posn 3 1)(make-posn 3 3)
      (make-posn 4 0)(make-posn 4 1)
      (make-posn 4 3)(make-posn 4 4)))

;; (c)
;; neighbours: Board -> (listof Board)
;; Purpose: produces a list with one element for each possible
;;          position at which to place the next queen. Each
;;          entry in the list is the board resulting from
;;          adding that queen to the given board. 
;; Examples:
(check-expect (neighbours (make-board 2))
              (list empty empty empty empty))
(check-expect (neighbours (make-board 3))
              (list
               (list(make-posn 1 2)(make-posn 2 1))
               (list(make-posn 2 0)(make-posn 2 2))
               (list(make-posn 1 0)(make-posn 2 1))
               (list(make-posn 0 2)(make-posn 2 2))
               empty
               (list(make-posn 0 0)(make-posn 2 0))
               (list(make-posn 0 1)(make-posn 1 2))
               (list(make-posn 0 0)(make-posn 0 2))
               (list(make-posn 0 1)(make-posn 1 0))))
;; Definition:
(define (neighbours aboard)
  (map (lambda(x) (add-queen aboard x)) aboard))
;; Tests:
(check-expect (neighbours (make-board 1))(list(list)))
(check-expect 
 (neighbours (make-board 4))
 (list
  (list(make-posn 1 2)(make-posn 1 3)(make-posn 2 1)
       (make-posn 2 3)(make-posn 3 1)(make-posn 3 2))
  (list(make-posn 1 3)(make-posn 2 0)(make-posn 2 2)
       (make-posn 3 0)(make-posn 3 2)(make-posn 3 3))
  (list(make-posn 1 0)(make-posn 2 1)(make-posn 2 3)
       (make-posn 3 0)(make-posn 3 1)(make-posn 3 3))
  (list(make-posn 1 0)(make-posn 1 1)(make-posn 2 0)
       (make-posn 2 2)(make-posn 3 1)(make-posn 3 2))
  (list(make-posn 0 2)(make-posn 0 3)(make-posn 2 2)
       (make-posn 2 3)(make-posn 3 1)(make-posn 3 3))
  (list(make-posn 0 3)(make-posn 2 3)
       (make-posn 3 0)(make-posn 3 2))
  (list(make-posn 0 0)(make-posn 2 0)
       (make-posn 3 1)(make-posn 3 3))
  (list(make-posn 0 0)(make-posn 0 1)(make-posn 2 0)
       (make-posn 2 1)(make-posn 3 0)(make-posn 3 2))
  (list(make-posn 0 1)(make-posn 0 3)(make-posn 1 2)
       (make-posn 1 3)(make-posn 3 2)(make-posn 3 3))
  (list(make-posn 0 0)(make-posn 0 2)
       (make-posn 1 3)(make-posn 3 3))
  (list(make-posn 0 1)(make-posn 0 3)
       (make-posn 1 0)(make-posn 3 0))
  (list(make-posn 0 0)(make-posn 0 2)(make-posn 1 0)
       (make-posn 1 1)(make-posn 3 0)(make-posn 3 1))
  (list(make-posn 0 1)(make-posn 0 2)(make-posn 1 1)
       (make-posn 1 3)(make-posn 2 2)(make-posn 2 3))
  (list(make-posn 0 0)(make-posn 0 2)(make-posn 0 3)
       (make-posn 1 0)(make-posn 1 2)(make-posn 2 3))
  (list(make-posn 0 0)(make-posn 0 1)(make-posn 0 3)
       (make-posn 1 1)(make-posn 1 3)(make-posn 2 0))
  (list(make-posn 0 1)(make-posn 0 2)(make-posn 1 0)
       (make-posn 1 2)(make-posn 2 0)(make-posn 2 1))))

;; (d)
;; find-route: Board Board Nat -> (union (listof Board) false)
;; Purpose: produces the sequence of board configurations that
;;          make up the path from orig to dest, if there is such
;;          a path of length n, or false if there is no path from
;;          orig to dest of length n.
;; Examples:
(check-expect 
 (find-route (make-board 3) empty 1)
 (list(list (make-posn 0 0)(make-posn 0 1)(make-posn 0 2)
            (make-posn 1 0)(make-posn 1 1)(make-posn 1 2)
            (make-posn 2 0)(make-posn 2 1)(make-posn 2 2))
      empty))
(check-expect (find-route (make-board 3) empty 3) false)
(check-expect
 (find-route (make-board 3) empty 2)
 (list(list (make-posn 0 0)(make-posn 0 1)(make-posn 0 2)
            (make-posn 1 0)(make-posn 1 1)(make-posn 1 2)
            (make-posn 2 0)(make-posn 2 1)(make-posn 2 2))
      (list (make-posn 1 2)(make-posn 2 1))
      empty))
(check-expect
 (find-route (make-board 3)(list (make-posn 2 1)(make-posn 1 2)) 1)
 (list(list (make-posn 0 0)(make-posn 0 1)(make-posn 0 2)
            (make-posn 1 0)(make-posn 1 1)(make-posn 1 2)
            (make-posn 2 0)(make-posn 2 1)(make-posn 2 2))
      (list (make-posn 1 2)(make-posn 2 1))))
;; Definition:
(define (find-route orig dest n)
  (cond
    [(zero? n)
     (cond
       [(eq-lists? orig dest) (list orig)]
       [else false])]
    [else
     (local
       [(define nbrs (neighbours orig))
        ;; find-route/list:  (listof Board) Int[>= 0] 
        ;;                -> (union (listof Board) false)
        ;; Purpose: produces the sequence of board configurations
        ;;          that make up the path from the first possible 
        ;;          board configuration contained in the list of 
        ;;          boards (l-nds) to dest given by function find-
        ;;          route, if there is such a path of length n-1,
        ;;          of false if there no path from first possible
        ;;          configuration contained in l-nds to dest given
        ;;          by find-route of length n-1.
        (define (find-route/list l-nds n)
          (cond
            [(empty? l-nds) false]
            [else
             (local
               [(define route (find-route (first l-nds) dest n))]
               (cond
                 [(boolean? route) (find-route/list (rest l-nds) n)]
                 [else route]))]))
        (define route (find-route/list nbrs (sub1 n)))]
       (cond
         [(boolean? route) false]
         [else (cons orig route)]))]))
;; Tests:
(check-expect (find-route empty empty 0) (list empty))
(check-expect (find-route empty (list (make-posn 1 1)) 3) false)
(check-expect (find-route (list (make-posn 3 2)(make-posn 2 3))
                          (list (make-posn 2 3)(make-posn 3 2)) 0)
              (list (list(make-posn 3 2)(make-posn 2 3))))
(check-expect (find-route (make-board 4) empty 2) false)
(check-expect (find-route (make-board 4) empty 3)
              (list (list(make-posn 0 0)(make-posn 0 1)
                         (make-posn 0 2)(make-posn 0 3)
                         (make-posn 1 0)(make-posn 1 1)
                         (make-posn 1 2)(make-posn 1 3)
                         (make-posn 2 0)(make-posn 2 1)
                         (make-posn 2 2)(make-posn 2 3)
                         (make-posn 3 0)(make-posn 3 1)
                         (make-posn 3 2)(make-posn 3 3))
                    (list(make-posn 1 2)(make-posn 1 3)
                         (make-posn 2 1)(make-posn 2 3)
                         (make-posn 3 1)(make-posn 3 2))
                    (list (make-posn 3 1))
                    empty))
(check-expect (find-route (make-board 4)
                          (list (make-posn 3 0)(make-posn 2 0)
                                (make-posn 3 2)) 2)
              (list (list(make-posn 0 0)(make-posn 0 1)
                         (make-posn 0 2)(make-posn 0 3)
                         (make-posn 1 0)(make-posn 1 1)
                         (make-posn 1 2)(make-posn 1 3)
                         (make-posn 2 0)(make-posn 2 1) 
                         (make-posn 2 2)(make-posn 2 3)
                         (make-posn 3 0)(make-posn 3 1)
                         (make-posn 3 2)(make-posn 3 3))
                    (list(make-posn 1 3)(make-posn 2 0)
                         (make-posn 2 2)(make-posn 3 0)
                         (make-posn 3 2)(make-posn 3 3))
                    (list(make-posn 2 0)(make-posn 3 0)
                         (make-posn 3 2))))

;; (e)
;; nqueens: Nat[>= 1] -> (union (listof Board) false)
;; Purpose: produces the first possible solution (if checking
;;          every square of board in order) of N-queens problem,
;;          if one exist, or false otherwise.
;; Examples:
(check-expect (nqueens 2) false)
(check-expect 
 (nqueens 5)
 (list (list(make-posn 0 0)(make-posn 0 1)(make-posn 0 2)
            (make-posn 0 3)(make-posn 0 4)(make-posn 1 0)
            (make-posn 1 1)(make-posn 1 2)(make-posn 1 3)
            (make-posn 1 4)(make-posn 2 0)(make-posn 2 1)
            (make-posn 2 2)(make-posn 2 3)(make-posn 2 4)
            (make-posn 3 0)(make-posn 3 1)(make-posn 3 2)
            (make-posn 3 3)(make-posn 3 4)(make-posn 4 0)
            (make-posn 4 1)(make-posn 4 2)(make-posn 4 3)
            (make-posn 4 4))
       (list(make-posn 1 2)(make-posn 1 3)(make-posn 1 4)
            (make-posn 2 1)(make-posn 2 3)(make-posn 2 4)
            (make-posn 3 1)(make-posn 3 2)(make-posn 3 4)
            (make-posn 4 1)(make-posn 4 2)(make-posn 4 3))
       (list(make-posn 2 4)(make-posn 3 1)(make-posn 4 1)
            (make-posn 4 3))
       (list (make-posn 3 1) (make-posn 4 1) (make-posn 4 3))
       (list (make-posn 4 3))
       empty))
;; Definition:
(define (nqueens n)
  (find-route (make-board n) empty n))
;; Tests:
(check-expect (nqueens 1)
              (list (list(make-posn 0 0))
                    empty))
(check-expect (nqueens 2) false)
(check-expect (nqueens 3) false)
(check-expect 
 (nqueens 6)
 (list (list(make-posn 0 0)(make-posn 0 1)(make-posn 0 2)
            (make-posn 0 3)(make-posn 0 4)(make-posn 0 5)
            (make-posn 1 0)(make-posn 1 1)(make-posn 1 2)
            (make-posn 1 3)(make-posn 1 4)(make-posn 1 5)
            (make-posn 2 0)(make-posn 2 1)(make-posn 2 2)
            (make-posn 2 3)(make-posn 2 4)(make-posn 2 5)
            (make-posn 3 0)(make-posn 3 1)(make-posn 3 2)
            (make-posn 3 3)(make-posn 3 4)(make-posn 3 5)
            (make-posn 4 0)(make-posn 4 1)(make-posn 4 2)
            (make-posn 4 3)(make-posn 4 4)(make-posn 4 5)
            (make-posn 5 0)(make-posn 5 1)(make-posn 5 2)
            (make-posn 5 3)(make-posn 5 4)(make-posn 5 5))
       (list(make-posn 1 3)(make-posn 1 4)(make-posn 1 5)
            (make-posn 2 0)(make-posn 2 2)(make-posn 2 4)
            (make-posn 2 5)(make-posn 3 0)(make-posn 3 2)
            (make-posn 3 3)(make-posn 3 5)(make-posn 4 0)
            (make-posn 4 2)(make-posn 4 3)(make-posn 4 4)
            (make-posn 5 0)(make-posn 5 2)(make-posn 5 3)
            (make-posn 5 4)(make-posn 5 5))
       (list(make-posn 2 0)(make-posn 2 5)(make-posn 3 0)
            (make-posn 3 2)(make-posn 4 2)(make-posn 4 4)
            (make-posn 5 0)(make-posn 5 2)(make-posn 5 4)
            (make-posn 5 5))
       (list(make-posn 3 0)(make-posn 3 2)(make-posn 4 2)
            (make-posn 4 4)(make-posn 5 0)(make-posn 5 4))
       (list(make-posn 4 2)(make-posn 4 4)(make-posn 5 4))
       (list (make-posn 5 4))
       empty))
 

;;
;; *************************************************
;;
;; Assignment 9, Question 2 (Bonus)
;; (dealing with the famous N-queens problem.)
;;
;; *************************************************
;;

;; neighbours2: Board -> (listof (list Board Posn))
;; Purpose: produces a list of association lists, where its
;;          first element is a board resulting from adding 
;;          one queen at a possible position in the given 
;;          board, and its second element is a posn, the 
;;          position at which each queen is added in the 
;;          given board (in order), which results in what
;;          the first element shows.
;; Examples:
(check-expect (neighbours2 (make-board 2))
              (list (list empty (make-posn 0 0))
                    (list empty (make-posn 0 1)) 
                    (list empty (make-posn 1 0))
                    (list empty (make-posn 1 1))))
(check-expect 
 (neighbours2 (make-board 3))
 (list
  (list (list(make-posn 1 2)(make-posn 2 1)) (make-posn 0 0))
  (list (list(make-posn 2 0)(make-posn 2 2)) (make-posn 0 1))
  (list (list(make-posn 1 0)(make-posn 2 1)) (make-posn 0 2))
  (list (list(make-posn 0 2)(make-posn 2 2)) (make-posn 1 0))
  (list empty (make-posn 1 1))
  (list (list(make-posn 0 0)(make-posn 2 0)) (make-posn 1 2))
  (list (list(make-posn 0 1)(make-posn 1 2)) (make-posn 2 0))
  (list (list(make-posn 0 0)(make-posn 0 2)) (make-posn 2 1))
  (list (list(make-posn 0 1)(make-posn 1 0)) (make-posn 2 2))))
;; Definition:
(define (neighbours2 aboard)
  (map (lambda(x) (list(add-queen aboard x) x)) aboard))  
;; Tests:
(check-expect (neighbours2 (make-board 1))
              (list (list empty (make-posn 0 0))))
(check-expect 
 (neighbours2 (make-board 4))
 (list
  (list (list(make-posn 1 2)(make-posn 1 3)(make-posn 2 1)
             (make-posn 2 3)(make-posn 3 1)(make-posn 3 2))
        (make-posn 0 0))
  (list (list(make-posn 1 3)(make-posn 2 0)(make-posn 2 2)
             (make-posn 3 0)(make-posn 3 2)(make-posn 3 3))
        (make-posn 0 1))
  (list (list(make-posn 1 0)(make-posn 2 1)(make-posn 2 3)
             (make-posn 3 0)(make-posn 3 1)(make-posn 3 3))
        (make-posn 0 2))
  (list (list(make-posn 1 0)(make-posn 1 1)(make-posn 2 0)
             (make-posn 2 2)(make-posn 3 1)(make-posn 3 2))
        (make-posn 0 3))
  (list (list(make-posn 0 2)(make-posn 0 3)(make-posn 2 2)
             (make-posn 2 3)(make-posn 3 1)(make-posn 3 3))
        (make-posn 1 0))
  (list (list(make-posn 0 3)(make-posn 2 3)
             (make-posn 3 0)(make-posn 3 2))
        (make-posn 1 1))
  (list (list(make-posn 0 0)(make-posn 2 0)
             (make-posn 3 1)(make-posn 3 3))
        (make-posn 1 2))
  (list (list(make-posn 0 0)(make-posn 0 1)(make-posn 2 0)
             (make-posn 2 1)(make-posn 3 0)(make-posn 3 2))
        (make-posn 1 3))
  (list (list(make-posn 0 1)(make-posn 0 3)(make-posn 1 2)
             (make-posn 1 3)(make-posn 3 2)(make-posn 3 3))
        (make-posn 2 0))
  (list (list(make-posn 0 0)(make-posn 0 2)
             (make-posn 1 3)(make-posn 3 3))
        (make-posn 2 1))
  (list (list(make-posn 0 1)(make-posn 0 3)
             (make-posn 1 0)(make-posn 3 0))
        (make-posn 2 2))
  (list (list(make-posn 0 0)(make-posn 0 2)(make-posn 1 0)
             (make-posn 1 1)(make-posn 3 0)(make-posn 3 1))
        (make-posn 2 3))
  (list (list(make-posn 0 1)(make-posn 0 2)(make-posn 1 1)
             (make-posn 1 3)(make-posn 2 2)(make-posn 2 3))
        (make-posn 3 0))
  (list (list(make-posn 0 0)(make-posn 0 2)(make-posn 0 3)
             (make-posn 1 0)(make-posn 1 2)(make-posn 2 3))
        (make-posn 3 1))
  (list (list(make-posn 0 0)(make-posn 0 1)(make-posn 0 3)
             (make-posn 1 1)(make-posn 1 3)(make-posn 2 0))
        (make-posn 3 2))
  (list (list(make-posn 0 1)(make-posn 0 2)(make-posn 1 0)
             (make-posn 1 2)(make-posn 2 0)(make-posn 2 1))
        (make-posn 3 3))))

;; find-route2: Board Board Nat -> (union (listof Posn) false)
;; Purpose: produces a list of positions at which each of queens 
;;          could be possibly added in orig in order, if there is 
;;          a path from orig to dest of length n, or false if there
;;          is no such path from orig to dest of length n. 
;; Examples:
(check-expect 
 (find-route2 (make-board 3) empty 1)
 (list (make-posn 1 1)))
(check-expect (find-route2 (make-board 3) empty 3) false)
(check-expect
 (find-route2 (make-board 3) empty 2)
 (list (make-posn 0 0)(make-posn 1 2)))
(check-expect
 (find-route2 (make-board 3)(list (make-posn 2 1)(make-posn 1 2)) 1)
 (list (make-posn 0 0)))
(check-expect (find-route2 (make-board 5) empty 2) false)
;; Definition:
(define (find-route2 orig dest n)
  (cond
    [(zero? n)
     (cond
       [(eq-lists? orig dest) empty]
       [else false])]
    [else
     (local
       [(define nbrs (neighbours2 orig))
        ;; find-route/list2:
        (define (find-route/list2 l-nds n)
          (cond
            [(empty? l-nds) false]
            [else
             (local
               [(define route
                  (find-route2 (first (first l-nds)) dest (sub1 n)))]
               (cond
                 [(boolean? route) (find-route/list2 (rest l-nds) n)]
                 [else (cons (second (first l-nds)) route)]))]))
        (define route (find-route/list2 nbrs n))]
       (cond
         [(boolean? route) false]
         [else route]))]))
;; Tests:
(check-expect (find-route2 empty empty 0) empty)
(check-expect 
 (find-route2 (make-board 1)(list(make-posn 0 0)) 0) empty)
(check-expect (find-route2 empty (list (make-posn 1 1)) 3) false)
(check-expect (find-route2 (list (make-posn 3 2)(make-posn 2 3))
                           (list (make-posn 2 3)(make-posn 3 2)) 0)
              empty)
(check-expect (find-route2 (make-board 4) empty 2) false)
(check-expect (find-route2 (make-board 4) empty 3)
              (list (make-posn 0 0)(make-posn 1 2)(make-posn 3 1)))
(check-expect (find-route2 (make-board 4)
                           (list (make-posn 3 0)(make-posn 2 0)
                                 (make-posn 3 2)) 2)
              (list (make-posn 0 1)(make-posn 1 3)))

;; nqueens2: Nat[>= 1] -> (union (listof Posn) false)
;; Purpose: produces the first possible solution (if checking
;;          every square of board in order) of N-queens problem,
;;          if one exist, or false otherwise.
;;          (produces the positions where queens occupy, if
;;          there exists at least one solution.)
;; Examples:
(check-expect (nqueens2 3) false)
(check-expect
 (nqueens2 4) (list (make-posn 0 1)(make-posn 1 3)
                    (make-posn 2 0)(make-posn 3 2)))
(check-expect
 (nqueens2 7) (list (make-posn 0 0)(make-posn 1 2)
                    (make-posn 2 4)(make-posn 3 6)
                    (make-posn 4 1)(make-posn 5 3)
                    (make-posn 6 5)))
;; Definition:
(define (nqueens2 n)
  (find-route2 (make-board n) empty n))
;; Tests:
(check-expect (nqueens2 1) (list (make-posn 0 0)))
(check-expect (nqueens2 2) false)
(check-expect 
 (nqueens2 5) (list (make-posn 0 0)(make-posn 1 2)
                    (make-posn 2 4)(make-posn 3 1)
                    (make-posn 4 3)))
(check-expect
 (nqueens2 8) (list (make-posn 0 0)(make-posn 1 4)
                    (make-posn 2 7)(make-posn 3 5)
                    (make-posn 4 2)(make-posn 5 6)
                    (make-posn 6 1)(make-posn 7 3)))


;; Helper function:
;; eq-lists? (listof Posn)(listof Posn) -> Boolean
;; Purpose: produces true iff the posns contained one list
;;          are the same as those contained the other list,
;;          ignoring the order of posns.
;; Examples:
(check-expect 
 (eq-lists? (list (make-posn 4 2)(make-posn 3 3))
            (list (make-posn 3 3)(make-posn 4 2))) true)
(check-expect
 (eq-lists? (list (make-posn 0 0)(make-posn 1 3)(make-posn 0 3))
            (list (make-posn 0 0)(make-posn 0 3)(make-posn 1 3)))
 true)
(check-expect
 (eq-lists? (list (make-posn 2 3)(make-posn 4 4))
            (list (make-posn 4 3)(make-posn 2 3))) false)
;; Definition:
(define (eq-lists? lst1 lst2)
  (local
    [(define pred (lambda(x y)(cond[(not(= (posn-x x)(posn-x y)))
                                    (< (posn-x x)(posn-x y))]
                                   [(not(= (posn-y x)(posn-y y)))
                                    (< (posn-y x)(posn-y y))]
                                   [else (equal? x y)])))]
    (equal? (quicksort lst1 pred)(quicksort lst2 pred))))
;; Tests:
(check-expect (eq-lists? empty empty) true)
(check-expect 
 (eq-lists? (list (make-posn 2 3)(make-posn 3 4))
            (list (make-posn 3 4)(make-posn 2 3))) true)
(check-expect
 (eq-lists? (list (make-posn 1 1)(make-posn 1 1)(make-posn 1 1))
            (list (make-posn 1 1)(make-posn 1 1)(make-posn 1 1)))
 true)
(check-expect
 (eq-lists? (list (make-posn 2 0)(make-posn 0 3)(make-posn 2 0)
                  (make-posn 1 2)(make-posn 1 2)(make-posn 2 1))
            (list (make-posn 0 3)(make-posn 1 2)(make-posn 1 2)
                  (make-posn 2 0)(make-posn 2 0)(make-posn 2 1)))
 true)
(check-expect
 (eq-lists? (list (make-posn 1 2)(make-posn 2 3))
            (list (make-posn 1 2))) false)

;; Equality of order-independent lists:
;; There are some other ways to determine whether two lists
;; are equivalent to each other regardless of the order of
;; elements of each list. (elements can be chosen freely) 

;; eq-lists?2: (listof Any)(listof Any) -> Boolean
(define (eq-lists?2 lst1 lst2)
  (and(foldr (lambda(x y)(cond [(member? x lst2) y]
                               [else false]))
             true
             lst1)
      (foldr (lambda(x y)(cond [(member? x lst1) y]
                               [else false]))
             true
             lst2)))
(check-expect (eq-lists?2 '() '()) true)
(check-expect (eq-lists?2 '(1 2) '(2 1)) true)
(check-expect (eq-lists?2 '(3 b) '(3 a b)) false)
(check-expect (eq-lists?2 '(3 c d) '(3 d)) false)
(check-expect (eq-lists?2 '(3 2 0) '(4 0 2)) false)
(check-expect (eq-lists?2 '(1 "cs" 0 6) '(4 "cs" 3)) false)

 ;;eq-lists?3: (listof Any)(listof Any) -> Boolean
(define (eq-lists?3 lst1 lst2)
  (and (andmap (lambda(x) (member? x lst2)) lst1)
       (andmap (lambda(x) (member? x lst1)) lst2)))
(check-expect (eq-lists?3 '() '()) true)
(check-expect (eq-lists?3 '(1 0 2) '(0 2 1)) true)
(check-expect (eq-lists?3 '(5 a) '(5 a b)) false)
(check-expect (eq-lists?3 '(4 e d) '(e 4)) false)
(check-expect (eq-lists?3 '(2 1 3) '(3 4 2)) false)
(check-expect (eq-lists?3 '(5 "Cs" 0 7) '("Cs" 0 3)) false)