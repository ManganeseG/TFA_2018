using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResetPuzzle : MonoBehaviour 
{
	void OnTriggerEnter(Collider col)
	{
		PuzzleTanvir.OneOk = false;
		PuzzleTanvir.SecOk = false;
	}
}
