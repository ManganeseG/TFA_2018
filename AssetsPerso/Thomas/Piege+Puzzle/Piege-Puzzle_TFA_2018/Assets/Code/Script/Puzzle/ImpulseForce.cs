	using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ImpulseForce : MonoBehaviour 
{
	public float force;
	public float Mindist = 0.0f;
	public float Maxdist = 5.0f;
	public Transform Player;
	public KeyCode ActivePush;
	public GameObject refTPuzzleSystem;

	public static bool HaveTrigger = false;

    private Rigidbody rb;
	private bool impulse = false;

	private Vector3 heading;
	private Vector3 dir;
	

    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

	void Update()
	{
		if(HaveTrigger && PuzzleTanvir.OneOk && PuzzleTanvir.SecOk)
		{
			rb.isKinematic = true;
			return;
		}
		
		heading = Player.position - transform.position;

		float dist = heading.magnitude;
		dir	= heading/dist;

		if(dist > Mindist && dist < Maxdist)
		{
			if(Input.GetKey(ActivePush))
			{
				impulse = true;
			}
		}
	}

    void FixedUpdate()
    {
		if(impulse)
		{
			rb.AddForce(-dir * force,ForceMode.Impulse);
			impulse = false;
    	}
	}

	void OnTriggerEnter(Collider col)
	{
		if(col.tag == "FirstPart")
		{
			PuzzleTanvir.OneOk = true;
		}
		else if(col.tag == "SecondPart")
		{
			PuzzleTanvir.SecOk = true;
		}
		refTPuzzleSystem.GetComponent<PuzzleTanvir>().PullTrigger(col);
	}
}
