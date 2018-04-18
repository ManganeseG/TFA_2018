using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GolemEnemy : MonoBehaviour 
{
	[Header ("Enemy Properties")]
    public int Score = 5;
	public float Health = 10.0f;
	public float WakeUpDistance = 5.0f;
	public float AttackDistance = 1.0f;
	public float MovingSpeed = 2.0f;
	public float Radius = 0.5f;
	public float MaxDist = 10.0f;
    public float MinDist = 5.0f;

	public static float health;

    private Vector3 playerPos;
    private Quaternion lookrotation;
	private Animator animatorGolem;
	private float distanceToPlayer;

	enum State
	{
		Sleeping,
		Moving,
		Dying
	}

	private State currentState = State.Sleeping;

	void Awake()
	{
		animatorGolem = GetComponent<Animator>();
		health = Health;
	}

	void Update()
	{
		distanceToPlayer = (transform.position - Player.Current.transform.position).magnitude;
		switch (currentState)
		{
			case State.Sleeping:
				{
					if (distanceToPlayer <= WakeUpDistance)
						currentState = State.Moving;
				}
				break;
			case State.Moving:
				move();
			    break;
			case State.Dying:
			{
				animatorGolem.SetBool("IsDeath", true);
			}
				break;
			default:
				break;
		}
		Debug.Log(distanceToPlayer);
		if(Input.GetKey(KeyCode.A))
			health = 0.0f;

		if(health <= 0.0f)
			currentState = State.Dying;
	}

	private void move()
	{
		bool forward = true;
		
		//CanWalk
		if (distanceToPlayer <= WakeUpDistance)
		{
			animatorGolem.SetBool("CanWalk",true);
			animatorGolem.SetBool("CanIdle",false);
			animatorGolem.SetBool("CanAttack",false);
			transform.LookAt(Player.Current.transform.position);
			forward = true;
		}
		//CanIdle
		if(distanceToPlayer >= WakeUpDistance)
		{
			animatorGolem.SetBool("CanIdle",true);
			animatorGolem.SetBool("CanWalk",false);
			forward = false;
		}
		//CanAttack
		if(distanceToPlayer <= AttackDistance)
		{
			animatorGolem.SetBool("CanAttack",true);
			animatorGolem.SetBool("CanWalk",false);
			transform.LookAt(Player.Current.transform.position);
			forward = false;
		}
		if(forward)
			transform.position += (transform.forward) * MovingSpeed * Time.deltaTime;
		else
			transform.position = transform.position;
	}

	void OnTriggerEnter(Collider col)
	{
		if (col.gameObject.layer == LayerMask.NameToLayer("Player"))
			 health--;
		
		if (health<=0.0f && currentState!=State.Dying)
		{
			currentState = State.Dying;
		}
	}

   
}
