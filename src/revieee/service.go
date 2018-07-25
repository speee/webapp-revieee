package revieee

type Service int

const (
	Github Service = iota
)

func (s Service) String() string {
	switch s {
	case Github:
		return "Github"
	default:
		panic("Undefined Service")
	}
}
