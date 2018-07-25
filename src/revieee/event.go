package revieee

type Event int

const (
	Create Event = iota
	Update
	Destroy
)

func (e Event) String() string {
	switch e {
	case Create:
		return "Create"
	case Update:
		return "Update"
	case Destroy:
		return "Destroy"
	default:
		panic("Undefined Event")
	}
}
