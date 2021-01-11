package dll

import (
	"fmt"
)

type node struct {
	i    int
	next *node
	prev *node
}

// DoublyLList is a simple doubly linked list
type DoublyLList struct {
	head *node
	tail *node
}

func (dll *DoublyLList) pushBack(val int) {
	newNode := &node{i: val, prev: dll.tail}
	if dll.head == nil {
		dll.head = newNode
		dll.tail = newNode
	} else {
		dll.tail.next = newNode
	}
	dll.tail = newNode
}

func (dll *DoublyLList) popBack() (int, error) {
	if dll.tail == nil {
		return 0, fmt.Errorf("Unable to pop from empty list")
	}
	val := dll.tail.i
	dll.tail = dll.tail.prev
	return val, nil
}
